%w[rubygems hoe].each { |f| require f }
require File.dirname(__FILE__) + '/lib/stubble'

Hoe.new('stubble', Stubble::VERSION) do |p|
  p.author = 'David Chelimsky'
  p.email = 'dchelimsky@gmail.com'
  p.summary = "stubble-#{Stubble::VERSION}"
  p.description = 'Tools to make stubbing ORM models just a little bit easier.'
  p.url = 'http://github.com/dchelimsky/stubble'
  p.extra_deps = [['activerecord']]
  p.extra_dev_deps = [["rspec >= 1.2.2"]]
  p.readme_file = 'README.rdoc'
  p.history_file = 'History.rdoc'
end

Dir['tasks/**/*.rake'].each { |t| load t }
task :default => [:spec]
