begin
  require 'spec'
rescue LoadError
  require 'rubygems'
  gem 'rspec'
  require 'spec'
end

$:.unshift(File.dirname(__FILE__) + '/../lib')
require 'ezormocks'

Spec::Runner.configure do |c|
  c.include(Ezormocks)
end
