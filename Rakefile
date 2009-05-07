%w[rubygems hoe].each { |f| require f }
require File.dirname(__FILE__) + '/lib/stubble'

Hoe.new('stubble', Stubble::VERSION) do |p|
  p.developer 'David Chelimsky','dchelimsky@gmail.com'
  p.summary = "stubble-#{Stubble::VERSION}"
  p.description = 'Tools to make stubbing ORM models just a little bit easier.'
  p.url = 'http://github.com/dchelimsky/stubble'
  p.extra_deps = [['activerecord']]
  p.extra_dev_deps = [["rspec",">= 1.2.4"]]
  p.readme_file = 'README.rdoc'
  p.history_file = 'History.rdoc'
end

Rake.application.instance_variable_get('@tasks').delete('default')

task :default => ["spec:rspec","spec:mocha"]

namespace :update do
  desc "update the manifest"
  task :manifest do
    system %q[touch Manifest.txt; rake check_manifest | grep -v "(in " | patch]
  end
end

namespace :spec do
  ['mocha','rr','flexmock','rspec'].each do |framework|
    desc "using #{framework}"
    task framework do
      ENV['MOCK_FRAMEWORK'] = framework
      system 'spec spec'
    end
  end
end


  
