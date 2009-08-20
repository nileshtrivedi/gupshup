# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{gupshup}
  s.version = "0.1.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Nilesh Trivedi"]
  s.date = %q{2009-08-17}
  s.description = %q{Ruby wrapper for SMSGupShup API}
  s.email = ["nilesh.tr@gmail.com"]
  s.extra_rdoc_files = ["History.txt", "Manifest.txt", "PostInstall.txt"]
  s.files = ["History.txt", "Manifest.txt", "PostInstall.txt", "README.rdoc", "Rakefile", "lib/gupshup.rb", "script/console", "script/destroy", "script/generate", "test/test_gupshup.rb", "test/test_helper.rb"]
  s.homepage = %q{http://github.com/nileshtrivedi/gupshup}
  s.post_install_message = %q{PostInstall.txt}
  s.rdoc_options = ["--main", "README.rdoc"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{gupshup}
  s.rubygems_version = %q{1.3.5}
  s.summary = %q{Ruby wrapper for SMSGupShup API}
  s.test_files = ["test/test_gupshup.rb", "test/test_helper.rb"]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<hoe>, [">= 2.3.3"])
    else
      s.add_dependency(%q<hoe>, [">= 2.3.3"])
    end
  else
    s.add_dependency(%q<hoe>, [">= 2.3.3"])
  end
end
