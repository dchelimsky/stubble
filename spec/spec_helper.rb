begin
  require 'spec'
rescue LoadError
  require 'rubygems'
  gem 'rspec'
  require 'spec'
end

$:.unshift(File.dirname(__FILE__) + '/../lib')
require 'stubble'

Spec::Runner.configure do |c|
  c.include(Stubble)
end

unless defined?(ActiveRecord)
  module ActiveRecord
    class RecordInvalid < StandardError
      def initialize(instance); end
    end
    
    class RecordNotFound < StandardError
    end
  end
end

if f = ENV['MOCK_FRAMEWORK']
  if f == 'mocha'
    require 'mocha'
    module Stubble::StubMethod
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
  
  Spec::Runner.configure {|c| c.mock_with ENV['MOCK_FRAMEWORK'].to_sym}
end
