module Ezormocks
  def ezormock(klass, options={:savable => true})
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
    
    klass.stub!(:find).and_return(instance)
    instance
  end
end