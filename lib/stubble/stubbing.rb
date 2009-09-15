require 'activesupport'

module Stubble
  class ParameterMismatchError < StandardError
  end

  class NoAccessError < StandardError
    def initialize(*args)
      super("Model was never accessed")
    end
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
    $current_stubble = {}
    options = {:as => :valid}.merge(options)
    instance_id = options[:id] ? options[:id].to_i : next_id

    instance = klass.new

    if options[:as] == :valid
      instance.extend(ValidModel)
      stub_and_invoke(klass, :create) do |*params|
        __record_stubbled_klass_access
        __generate_stubble_instance(instance.with_id(instance_id), options, params.first)
      end
      stub_and_invoke(klass, :create!) do |*params|
        __record_stubbled_klass_access
        __generate_stubble_instance(instance.with_id(instance_id), options, params.first)
      end
    else
      instance.extend(InvalidModel)
      stub_and_invoke(klass, :create) do
        __record_stubbled_klass_access
        instance.with_id(nil)
      end
      stub_and_invoke(klass, :create!) do
        __record_stubbled_klass_access
        raise ActiveRecord::RecordInvalid.new(instance)
      end
    end

    instance.with_id(instance_id)

    stub_and_invoke(klass, :new) do |*params|
      __record_stubbled_klass_access
      __generate_stubble_instance(instance.with_id(nil), options, params.first)
    end
    stub_and_invoke(klass, :find) do |*args|
      __record_stubbled_klass_access
      args.first == :all ? [instance.with_id(instance_id)] :
        args.first.to_i == instance_id ? instance.with_id(instance_id) :
          (raise ActiveRecord::RecordNotFound.new(instance))
    end
    stub_and_invoke(klass, :all) { klass.find(:all) }

    instance
  end

  def __record_stubbled_klass_access
    $current_stubble[:accessed] = true
    yield if block_given?
  end

  def __generate_stubble_instance(instance, opts, params)
    if opts[:params]
      expected = opts[:params].stringify_keys
      actual   = params ? params.stringify_keys : nil
      raise ParameterMismatchError.new("Expected params: #{expected.inspect}\n            got: #{actual.inspect}") unless expected == actual
    end
    return instance
  end

  def __verify_stubble
    raise NoAccessError.new unless $current_stubble[:accessed]
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
    __verify_stubble
    reset
  end
end
