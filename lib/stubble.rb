lib = File.expand_path(File.dirname(__FILE__))
$:.unshift(lib) unless $:.include?(lib)

module Stubble
  VERSION = '0.0.0'
  
  module Unsavable
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
  
  def stubble(klass, options={:savable => true})
    instance = stub(klass).as_null_object

    if options[:savable]
      klass.stub!(:create!) {instance}
    else
      klass.stub!(:create!) {raise ActiveRecord::RecordInvalid.new(instance)}
      instance.extend Unsavable
    end

    klass.stub!(:new)   { instance }
    klass.stub!(:create){ instance }
    klass.stub!(:all)   {[instance]}
    
    if options[:id]
      klass.stub!(:find).and_raise(ActiveRecord::RecordNotFound.new)
      klass.stub!(:find).with(options[:id]).and_return(instance)
    else
      klass.stub!(:find) do |*args|
        args.first == :all ? [instance] : instance
      end
    end

    yield instance if block_given?

    instance
  end
end