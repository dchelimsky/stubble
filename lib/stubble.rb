lib = File.expand_path(File.dirname(__FILE__))
$:.unshift(lib) unless $:.include?(lib)

module Stubble
  VERSION = '0.0.0'
  
  module StubMethod
    def stub_method(obj, method, &block)
      obj.stub(method, &block)
    end
  end
  include StubMethod
  
  module ValidModel
    class << self
      include StubMethod
      def extended(instance)
        [:save, :save!, :update_attribute, :update_attributes, :update_attributes!, :valid?].each do |method|
          stub_method(instance, method) {true}
        end
      end
    end
  end
  
  module InvalidModel
    class << self
      include StubMethod
      def extended(instance)
        [:save!, :update_attributes!].each do |method|
          stub_method(instance, method) {raise ActiveRecord::RecordInvalid.new(instance)}
        end
        [:save, :update_attribute, :update_attributes, :valid?].each do |method|
          stub_method(instance, method) {false}
        end
      end
    end
  end
  
  def build_stubs(klass, options={:as => :valid})
    instance = stub(klass).as_null_object
    if options[:as] == :valid
      instance.extend(ValidModel)
      stub_method(klass, :create!) {instance}
    else
      instance.extend(InvalidModel)
      stub_method(klass, :create!) {raise ActiveRecord::RecordInvalid.new(instance)}
    end

    stub_method(klass, :new) {instance}
    stub_method(klass, :create) {instance}
    stub_method(klass, :all) {[instance]}

    if options[:id]
      stub_method(klass, :find) do |*args|
        if args.first.to_i == options[:id].to_i
          instance
        else
          raise ActiveRecord::RecordNotFound.new
        end
      end
    else
      stub_method(klass, :find) do |*args|
        args.first == :all ? [instance] : instance
      end
    end

    instance
  end
  
  def stubbing(klass, options={:as => :valid})
    yield build_stubs(klass, options)
  end
end