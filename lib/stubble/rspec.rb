module Stubble
  module StubMethod
    include Stubble::Callbacks
    
    def setup_callbacks
      stub_and_return     {|obj, method, value| obj.stub(method).and_return(value)}
      stub_with_one_arg   {|obj, method, with, value| obj.stub(method).with(with).and_return(value)}
      stub_with_multi_arg {|obj, method, with, value| obj.stub(method).with(with, anything).and_return(value)}
      stub_and_raise      {|obj, method, error| obj.stub(method).and_raise(error)}
      reset               {$rspec_mocks.reset_all}
    end
  end
end
  