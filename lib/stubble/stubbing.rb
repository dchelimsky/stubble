module Stubble
  VERSION = '0.0.0'
  
  include StubMethod
  
  module ValidModel
    class << self
      include StubMethod
      def extended(instance)
        setup_callbacks
        [:save, :save!, :update_attribute, :update_attributes, :update_attributes!, :valid?].each do |method|
          stub_and_return.call(instance, method, true)
        end
      end
    end
  end
  
  module InvalidModel
    class << self
      include StubMethod
      def extended(instance)
        setup_callbacks
        [:save!, :update_attributes!].each do |method|
          stub_and_raise.call(instance, method, ActiveRecord::RecordInvalid.new(instance))
        end
        [:save, :update_attribute, :update_attributes, :valid?].each do |method|
          stub_and_return.call(instance, method, false)
        end
      end
    end
  end
  
  def build_stubs(klass, options={}) 
    setup_callbacks
    instance = klass.new
    case options[:as]
      when :invalid
        instance.extend(InvalidModel)
        stub_and_raise.call(klass, :create!, ActiveRecord::RecordInvalid.new(instance))
      when :unfindable
        stub_and_raise.call(klass, :find, ActiveRecord::RecordNotFound.new(instance))
      else
        instance.extend(ValidModel)
        stub_and_return.call(klass, :create!, instance)
      end

    stub_and_return.call(klass, :new, instance)
    stub_and_return.call(klass, :create, instance)
    stub_and_return.call(klass, :all, [instance])

    unless options[:as] == :unfindable
      stub_and_return.call(klass, :find, instance)
      stub_with_one_arg.call(klass, :find, :all, [instance])
      stub_with_multi_arg.call(klass, :find, :all, [instance])
    end

    instance
  end
  
  def stubbing(klass, options={:as => :valid})
    instance = build_stubs(klass, options)
    yield instance
    reset.call
  end
end