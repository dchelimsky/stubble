require 'mocha'
module Stubble
  module StubMethod
    include Mocha::Standalone
    def stub_method(obj, method, options={})
      if options[:raise]
        obj.stubs(method).raises(options[:raise])
      elsif options[:return]
        if options[:with]
          obj.stubs(method).with(options[:with]).returns(options[:return])
          obj.stubs(method).with(options[:with], anything).returns(options[:return])
        else              
          obj.stubs(method).returns(options[:return])
        end
      else
        obj.stubs(method)
      end
    end
  
    def reset
      mocha_teardown
    end
  end
end
