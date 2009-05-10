module Stubble
  VERSION = '0.0.0'
  
  include Unimock
  
  module ValidModel
    class << self
      include Unimock
      def extended(model)
        [:save, :save!, :update_attribute, :update_attributes, :update_attributes!, :valid?].each do |method|
          stub_and_return(model, method, true)
        end
      end
    end
  end
  
  module InvalidModel
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
  
  def build_stubs(klass, options={}) 
    instance = klass.new
    case options[:as]
      when :invalid
        instance.extend(InvalidModel)
        stub_and_raise(klass, :create!, ActiveRecord::RecordInvalid.new(instance))
      when :unfindable
        stub_and_raise(klass, :find, ActiveRecord::RecordNotFound.new(instance))
      else
        instance.extend(ValidModel)
        stub_and_return(klass, :create!, instance)
      end

    stub_and_return(klass, :new, instance)
    stub_and_return(klass, :create, instance)
    stub_and_return(klass, :all, [instance])

    unless options[:as] == :unfindable
      stub_and_invoke(klass, :find) do |*args|
        args.first == :all ? [instance] : instance
      end
    end

    instance
  end
  
  def stubbing(klass, options={:as => :valid})
    instance = build_stubs(klass, options)
    yield instance
    reset
  end
end