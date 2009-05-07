module Stubble
  module StubMethod
    def stub_method(obj, method, options={})
      if options[:raise]
        obj.stub(method).and_raise(options[:raise])
      elsif options[:return]
        if options[:with]
          obj.stub(method).with(options[:with]).and_return(options[:return])
          obj.stub(method).with(options[:with], anything).and_return(options[:return])
        else
          obj.stub(method).and_return(options[:return])
        end
      else
        obj.stub(method)
      end
    end
  
    def reset
      $rspec_mocks.reset_all
    end
  end
end
  