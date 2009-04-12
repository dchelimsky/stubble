%w[rubygems rake rake/clean fileutils newgem rubigen echoe].each { |f| require f }
require File.dirname(__FILE__) + '/lib/stubble'

# Generate all the Rake tasks
# Run 'rake -T' to see list of generated tasks (from gem root directory)
Echoe.new('stubble', Ezormocks::VERSION) do |p|
  p.author = 'David Chelimsky'
  p.email = 'dchelimsky@gmail.com'
  p.summary = 'Tools to make mocking and stubbing ORM models just a little bit easier.'
  p.url = 'http://github.com/dchelimsky/stubble'
  p.runtime_dependencies = ['activerecord']
  p.development_dependencies = ["rspec >= 1.1.11"]
  p.retain_gemspec = false
  p.require_signed = false
  p.manifest_name = 'Manifest.txt'
end

Dir['tasks/**/*.rake'].each { |t| load t }
task :default => [:spec]
