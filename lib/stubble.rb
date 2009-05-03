lib = File.expand_path(File.dirname(__FILE__))
$:.unshift(lib) unless $:.include?(lib)

module Stubble
  VERSION = '0.0.0'

  def stubble(klass, options={:savable => true})
    instance = stub(
      klass,
      :save => options[:savable],
      :update_attribute => options[:savable],
      :update_attributes => options[:savable]
    ).as_null_object

    [:save!, :update_attributes!].each do |method|
      if options[:savable]
        instance.stub!(method).and_return(true)
      else
        instance.stub!(method).and_raise(ActiveRecord::RecordInvalid.new(instance))
      end
    end
    instance.stub!(:valid?).and_return(options[:savable])

    klass.stub!(:new).and_return(instance)
    klass.stub!(:all).and_return([instance])
    
    if options[:id]
      klass.stub!(:find).and_raise(ActiveRecord::RecordNotFound.new)
      klass.stub!(:find).with(options[:id]).and_return(instance)
    else
      klass.stub!(:find) do |*args|
        if !args.empty? && args.first == :all
          [instance]
        else
          instance
        end
      end
    end

    yield instance if block_given?

    instance
  end
end