require 'mocha'

module Mocha
  class Expectation
    alias_method :orig_returns, :returns
    def returns(*values, &block)
      @stubble_block = block
      orig_returns(*values)
    end
    
    alias_method :orig_invoke, :invoke
    def invoke
      @stubble_block ? @stubble_block.call(*@actual_parameters) : orig_invoke
    end
    
    alias_method :orig_match?, :match?
    def match?(actual_method_name, *actual_parameters)
      @actual_parameters = actual_parameters
      orig_match?(actual_method_name, *actual_parameters)
    end
  end
end

module Unimock
  include Mocha::Standalone
  
  def stub_and_return(obj, method, value)
    obj.stubs(method).returns(value)
  end
  
  def stub_and_raise(obj, method, error)
    obj.stubs(method).raises(error)
  end
  
  def stub_and_invoke(obj, method, &block)
    obj.stubs(method).returns(&block)
  end

  def reset
    mocha_teardown
  end
end
