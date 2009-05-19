module Stubble
  include Unimock
  
  module IdentifiableModel
    def with_id(id)
      self.id = id
      self
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
      stub_and_invoke(klass, :create) {instance.with_id(instance_id)}
      stub_and_invoke(klass, :create!) {instance.with_id(instance_id)}
    else
      instance.extend(InvalidModel)
      stub_and_invoke(klass, :create) {instance.with_id(nil)}
      stub_and_raise(klass, :create!, ActiveRecord::RecordInvalid.new(instance))
    end

    stub_and_invoke(klass, :new) {instance.with_id(nil)}
    stub_and_return(klass, :all, [instance.with_id(instance_id)])
    stub_and_invoke(klass, :find) do |*args|
      args.first == :all ? [instance.with_id(instance_id)] :
        args.first.to_i == instance_id ? instance.with_id(instance_id) :
          (raise ActiveRecord::RecordNotFound.new(instance))
    end

    instance
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