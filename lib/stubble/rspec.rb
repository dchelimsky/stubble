module Stubble
  module StubMethod
    def stub_and_return(obj, method, value)
      obj.stub(method).and_return(value)
    end
    
    def stub_and_raise(obj, method, error)
      obj.stub(method).and_raise(error)
    end
    
    def stub_and_invoke(obj, method, &block)
      obj.stub(method, &block)
    end

    def reset
      $rspec_mocks.reset_all
    end
  end
end
  