module Stubble
  class ParameterMismatchError < StandardError
  end
  
  include Unimock
  
  module IdentifiableModel
    def with_id(id)
      self.id = id
      self
    end
    
    def new_record?
      !id
    end
  end
  
  module ValidModel # :nodoc:
    include IdentifiableModel
    class << self
      include Unimock
      def extended(model)
        [:save, :save!, :update_attribute, :update_attributes, :update_attributes!, :valid?].each do |method|
          stub_and_return(model, method, true)
        end
      end
    end
  end
  
  module InvalidModel # :nodoc:
    include IdentifiableModel
    class << self
      include Unimock
      def extended(model)
        [:save!, :update_attributes!].each do |method|
          stub_and_raise(model, method, ActiveRecord::RecordInvalid.new(model))
        end
        [:save, :update_attribute, :update_attributes, :valid?].each do |method|
          stub_and_return(model, method, false)
        end
      end
    end
  end
  
  @@model_id = 1000
  
  def next_id
    @@model_id += 1
  end
  
  def build_stubs(klass, options={}) # :nodoc:
    options = {:as => :valid}.merge(options)
    instance_id = options[:id] ? options[:id].to_i : next_id
    
    instance = klass.new

    if options[:as] == :valid
      instance.extend(ValidModel)
      stub_and_invoke(klass, :create) {|*params| generate_instance(instance.with_id(instance_id), options, params.first)}
      stub_and_invoke(klass, :create!) {|*params| generate_instance(instance.with_id(instance_id), options, params.first)}
    else
      instance.extend(InvalidModel)
      stub_and_invoke(klass, :create) {instance.with_id(nil)}
      stub_and_raise(klass, :create!, ActiveRecord::RecordInvalid.new(instance))
    end

    stub_and_invoke(klass, :new) {|*params| generate_instance(instance.with_id(nil), options, params.first)}
    stub_and_return(klass, :all, [instance.with_id(instance_id)])
    stub_and_invoke(klass, :find) do |*args|
      args.first == :all ? [instance.with_id(instance_id)] :
        args.first.to_i == instance_id ? instance.with_id(instance_id) :
          (raise ActiveRecord::RecordNotFound.new(instance))
    end

    instance
  end
  
  def generate_instance(instance, opts, params)
    if opts[:params]
      expected, actual = stringify_keys(opts[:params]), stringify_keys(params)
      raise ParameterMismatchError.new("Expected params: #{expected.inspect}\n            got: #{actual.inspect}") unless expected == actual
    end
    return instance
  end
  
  def stringify_keys(hash)
    hash.inject({}) do |options, (key, value)|
      options[key.to_s] = value
      options
    end
  end
  
  # :call-seq:
  #   stubbing(Thing)                 {|thing| ... }
  #   stubbing(Thing, :as => invalid) {|thing| ... }
  #   stubbing(Thing, :id => "37")    {|thing| ... }
  #
  # See README.rdoc for more info
  def stubbing(klass, options={:as => :valid})
    instance = build_stubs(klass, options)
    yield instance
    reset
  end
end