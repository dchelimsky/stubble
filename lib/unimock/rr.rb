require 'rr'

module Unimock
  include ::RR::Extensions::InstanceMethods
  
  def stub_and_return(obj, method, value)
    stub(obj).__send__(method) {value}
  end
  
  def stub_and_raise(obj, method, error)
    stub(obj).__send__(method) {raise error}
  end
  
  def stub_and_invoke(obj, method, &block)
    stub(obj).__send__(method, &block)
  end

  def reset
    ::RR::Space.instance.reset
  end
end
