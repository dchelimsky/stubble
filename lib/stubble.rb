lib = File.expand_path(File.dirname(__FILE__))
$:.unshift(lib) unless $:.include?(lib)

module Stubble
  VERSION = '0.0.0'
  
  module ValidModel
    class << self
      def extended(instance)
        [:save, :save!, :update_attribute, :update_attributes, :update_attributes!, :valid?].each do |method|
          instance.stub!(method) {true}
        end
      end
    end
  end
  
  module InvalidModel
    class << self
      def extended(instance)
        [:save!, :update_attributes!].each do |method|
          instance.stub!(method) {raise ActiveRecord::RecordInvalid.new(instance)}
        end
        [:save, :update_attribute, :update_attributes, :valid?].each do |method|
          instance.stub!(method) {false}
        end
      end
    end
  end
  
  def build_stubs(klass, options={:savable => true})
    instance = stub(klass).as_null_object
    if options[:savable]
      instance.extend(ValidModel)
      klass.stub(:create!) {instance}
    else
      instance.extend(InvalidModel)
      klass.stub(:create!) {raise ActiveRecord::RecordInvalid.new(instance)}
    end

    klass.stub(:new)   { instance }
    klass.stub(:create){ instance }
    klass.stub(:all)   {[instance]}

    if options[:id]
      klass.stub(:find).and_raise(ActiveRecord::RecordNotFound.new)
      klass.stub(:find).with(options[:id]).and_return(instance)
    else
      klass.stub(:find) do |*args|
        args.first == :all ? [instance] : instance
      end
    end

    instance
  end
  
  def stubbing(klass, options={:savable => true})
    yield build_stubs(klass, options)
  end
end