module Stubble
  VERSION = '0.0.0'
  
  include Unimock
  
  module ValidModel # :nodoc:
    include Unimock
    class << self
      include Unimock
      def extended(model)
        [:save, :save!, :update_attribute, :update_attributes, :update_attributes!, :valid?].each do |method|
          stub_and_return(model, method, true)
        end
      end
    end
    
    def with_id(id)
      stub_and_return(self, :id, nil)
      self
    end
  end
  
  module InvalidModel # :nodoc:
    include Unimock
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
    
    def with_id(id)
      stub_and_return(self, :id, nil)
      self
    end
  end
  
  @@model_id = 1000
  
  def next_id
    @@model_id += 1
  end
  
  def build_stubs(klass, options={}) # :nodoc:
    options = {:as => :valid}.merge(options)
    options[:id] = options[:id].to_i if options[:id]
    
    instance = klass.new
    stub_and_return(klass, :all, [instance])

    if options[:as] == :valid
      instance.extend(ValidModel)
      stub_and_return(instance, :id, options[:id] || next_id)
      stub_and_return(klass, :create!, instance)
      stub_and_return(klass, :create, instance)
    else
      instance.extend(InvalidModel)
      stub_and_raise(klass, :create!, ActiveRecord::RecordInvalid.new(instance))
      stub_and_invoke(klass, :create) {instance.with_id(nil)}
    end

    stub_and_invoke(klass, :new) {instance.with_id(nil)}

    stub_and_invoke(klass, :find) do |*args|
      args.first == :all ? [instance] :
        args.first.to_i == instance.id ? instance :
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