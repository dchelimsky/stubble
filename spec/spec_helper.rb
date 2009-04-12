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
  end
end
