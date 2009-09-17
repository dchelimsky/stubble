require 'activesupport'

puts `rm -rf tmp`
puts `mkdir tmp`

Dir.chdir('tmp') do
  cmd = <<-CMD
rails example && cd example && \
script/generate rspec && \
script/generate rspec_model thing && \
rake db:migrate && rake db:test:prepare
CMD
  `#{cmd}`
end

FileUtils.mkdir_p('./tmp/example/spec/support')
File.open('./tmp/example/spec/support/stubble.rb','w') do |f|
  f.write <<-EOF
require 'stubble'
Stubble.configure {|s| s.stub_with :rspec}
Spec::Runner.configure {|c| c.include(Stubble)}
EOF
end