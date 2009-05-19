begin
  require 'spec'
rescue LoadError
  require 'rubygems'
  gem 'rspec'
  require 'spec'
end

$:.unshift(File.dirname(__FILE__) + '/../lib')
require 'stubble'

unless defined?(ActiveRecord)
  module ActiveRecord
    class RecordInvalid < StandardError
      def initialize(instance); end
    end
    
    class RecordNotFound < StandardError
    end
  end
end

ENV['STUB_FRAMEWORK'] ||= 'rspec'

Stubble.configure do |c|
  c.stub_with ENV['STUB_FRAMEWORK']
end

Spec::Runner.configure do |c|
  c.include(Stubble)
  c.mock_with ENV['STUB_FRAMEWORK'].to_sym
end

