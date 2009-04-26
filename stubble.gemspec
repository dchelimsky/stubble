# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{stubble}
  s.version = "0.0.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 1.2") if s.respond_to? :required_rubygems_version=
  s.authors = ["David Chelimsky"]
  s.date = %q{2009-04-26}
  s.description = %q{Tools to make stubbing ORM models just a little bit easier.}
  s.email = %q{dchelimsky@gmail.com}
  s.extra_rdoc_files = ["lib/stubble.rb", "README.markdown", "tasks/rspec.rake"]
  s.files = ["History.txt", "lib/stubble.rb", "Manifest.txt", "Rakefile", "README.markdown", "spec/spec.opts", "spec/spec_helper.rb", "spec/stubble_spec.rb", "tasks/rspec.rake", "stubble.gemspec"]
  s.has_rdoc = true
  s.homepage = %q{http://github.com/dchelimsky/stubble}
  s.rdoc_options = ["--line-numbers", "--inline-source", "--title", "Stubble", "--main", "README.markdown"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{stubble}
  s.rubygems_version = %q{1.3.2}
  s.summary = %q{Tools to make stubbing ORM models just a little bit easier.}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<activerecord>, [">= 0"])
      s.add_development_dependency(%q<rspec>, [">= 0", "= 1.2.2"])
    else
      s.add_dependency(%q<activerecord>, [">= 0"])
      s.add_dependency(%q<rspec>, [">= 0", "= 1.2.2"])
    end
  else
    s.add_dependency(%q<activerecord>, [">= 0"])
    s.add_dependency(%q<rspec>, [">= 0", "= 1.2.2"])
  end
end
