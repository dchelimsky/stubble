lib = File.expand_path(File.dirname(__FILE__))
$:.unshift(lib) unless $:.include?(lib)

ENV['STUBBLE_MOCK_FRAMEWORK'] ||= 'rspec'

require "unimock/#{ENV['STUBBLE_MOCK_FRAMEWORK']}"
require 'stubble/stubbing'