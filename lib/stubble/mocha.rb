require 'mocha'
module Stubble
  module StubMethod
    include Stubble::Callbacks
    include Mocha::Standalone
    
    def setup_callbacks
      stub_and_return     {|obj, method, value| obj.stubs(method).returns(value)}
      stub_with_one_arg   {|obj, method, with, value| obj.stubs(method).with(with).returns(value)}
      stub_with_multi_arg {|obj, method, with, value| obj.stubs(method).with(with, anything).returns(value)}
      stub_and_raise      {|obj, method, error| obj.stubs(method).raises(error)}
      reset               {mocha_teardown}
    end

  end
end
