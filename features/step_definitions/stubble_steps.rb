require 'tempfile'
include RubyForker

def ruby(args)
  stderr_file = Tempfile.new('rspec')
  stderr_file.close
  stubble_lib = File.expand_path(File.join(File.dirname(__FILE__),"..","..","lib"))
  Dir.chdir('./tmp/example') do
    @stdout = super("-I#{stubble_lib} #{args}", stderr_file.path)
  end
  @stderr = IO.read(stderr_file.path)
  @exit_code = $?.to_i
end

Given /^"([^\"]*)" with$/ do |file, string|
  path = "./tmp/example/#{file}"
  FileUtils.mkdir_p File.dirname(path)
  File.open(path, 'w') do |f|
    f.write(string)
  end
end

When /^I run "([^\"]*)"$/ do |file|
  ruby("-S spec #{file}")
end

Then /^I should see "([^\"]*)"$/ do |text|
  @stdout.should =~ /#{text}/i
end
