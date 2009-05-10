require 'rubygems' unless ENV['NO_RUBYGEMS']
require 'flexmock/rspec'

module Stubble
  module StubMethod
    include FlexMock::MockContainer
    def stub_and_return(obj, method, value)
      flexmock(obj).should_receive(method).and_return(value)
    end
    
    def stub_and_raise(obj, method, error)
      flexmock(obj).should_receive(method).and_raise(error)
    end
    
    def stub_and_invoke(obj, method, &block)
      flexmock(obj).should_receive(method).and_return(&block)
    end

    def reset
      flexmock_close
    end
  end
end
