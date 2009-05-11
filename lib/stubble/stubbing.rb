module Stubble
  VERSION = '0.0.0'
  
  include Unimock
  
  module ValidModel # :nodoc:
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
  
  def build_stubs(klass, options={:as => :valid}) # :nodoc:
    instance = klass.new
    stub_and_return(klass, :new, instance)
    stub_and_return(klass, :create, instance)
    stub_and_return(klass, :all, [instance])

    if options[:as] == :valid
      instance.extend(ValidModel)
      stub_and_return(klass, :create!, instance)
    else
      instance.extend(InvalidModel)
      stub_and_raise(klass, :create!, ActiveRecord::RecordInvalid.new(instance))
    end

    if options[:id]
      stub_and_invoke(klass, :find) do |*args|
        args.first.to_i == options[:id].to_i ? instance : (raise ActiveRecord::RecordNotFound.new(instance))
      end
    else
      stub_and_invoke(klass, :find) do |*args|
        args.first == :all ? [instance] : instance
      end
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