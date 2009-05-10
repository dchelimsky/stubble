require 'mocha'

module Stubble
  module StubMethod
    include Mocha::Standalone
    
    def setup_callbacks
      stub_and_return     {|obj, method, value| obj.stubss(method).returns(value)}
      stub_with_one_arg   {|obj, method, with, value| obj.stubss(method).with(with).returns(value)}
      stub_with_multi_arg {|obj, method, with, value| obj.stubss(method).with(with, anything).returns(value)}
      stub_and_raise      {|obj, method, error| obj.stubss(method).raises(error)}
      reset               {mocha_teardown}
    end
    
    def stub_and_return(obj, method, value)
      obj.stubs(method).returns(value)
    end
    
    def stub_and_raise(obj, method, error)
      obj.stubs(method).raises(error)
    end
    
    def fake(obj, method, &block)
      obj.stubs(method).returns &block
    end

    def reset
      mocha_teardown
    end
  end
end
