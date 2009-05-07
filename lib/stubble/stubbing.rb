module Stubble
  VERSION = '0.0.0'
  
  include StubMethod
  
  module ValidModel
    class << self
      include StubMethod
      def extended(instance)
        [:save, :save!, :update_attribute, :update_attributes, :update_attributes!, :valid?].each do |method|
          stub_method(instance, method, :return => true)
        end
      end
    end
  end
  
  module InvalidModel
    class << self
      include StubMethod
      def extended(instance)
        [:save!, :update_attributes!].each do |method|
          stub_method(instance, method, :raise => ActiveRecord::RecordInvalid.new(instance))
        end
        [:save, :update_attribute, :update_attributes, :valid?].each do |method|
          stub_method(instance, method, :return => false)
        end
      end
    end
  end
  
  def build_stubs(klass, options={}) 
    instance = klass.new
    case options[:as]
      when :invalid
        instance.extend(InvalidModel)
        stub_method(klass, :create!, :raise => ActiveRecord::RecordInvalid.new(instance))
      when :unfindable
        stub_method(klass, :find, :raise => ActiveRecord::RecordNotFound.new)
      else
        instance.extend(ValidModel)
        stub_method(klass, :create!, :return => instance)
      end

    stub_method(klass, :new, :return => instance)
    stub_method(klass, :create, :return => instance)
    stub_method(klass, :all, :return => [instance])

    unless options[:as] == :unfindable
      stub_method(klass, :find, :return => instance)
      stub_method(klass, :find, :with => :all, :return => [instance])
    end

    instance
  end
  
  def stubbing(klass, options={:as => :valid})
    instance = build_stubs(klass, options)
    yield instance
    reset
  end
end