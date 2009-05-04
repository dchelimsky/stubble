lib = File.expand_path(File.dirname(__FILE__))
$:.unshift(lib) unless $:.include?(lib)

module Stubble
  VERSION = '0.0.0'
  
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
  
  def stub_class(klass, instance, options)
    if options[:savable]
      klass.stub(:create!) {instance}
    else
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
  end
  
  def stub_instance(klass, instance, options)
    instance = stub(klass).as_null_object
    unless options[:savable]
      instance.extend InvalidModel
    end
    instance
  end
  
  def stubbing(klass, options={:savable => true})
    instance = stub_instance(klass, instance, options)
    stub_class(klass, instance, options)

    yield instance if block_given?

    instance
  end
end