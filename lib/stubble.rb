lib = File.expand_path(File.dirname(__FILE__))
$:.unshift(lib) unless $:.include?(lib)

module Stubble
  VERSION = '0.0.0'
  class << self
    def configure
      yield Class.new {
        def stub_with(framework)
          require "unimock/#{framework}"
          require 'stubble/stubbing'
        end
      }.new
    end
  end
end
