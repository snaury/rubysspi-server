# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{rubysspi-server}
  s.version = "0.0.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Alexey Borzenkov"]
  s.date = %q{2009-05-20}
  s.email = %q{snaury@gmail.com}
  s.extra_rdoc_files = [
    "LICENSE.txt",
     "README.txt"
  ]
  s.files = [
    "LICENSE.txt",
     "README.txt",
     "Rakefile",
     "VERSION.yml",
     "lib/win32/sspi/server.rb",
     "rubysspi-server.gemspec"
  ]
  s.has_rdoc = true
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.1}
  s.summary = %q{A library which implements Ruby server bindings to the Win32 SSPI library.}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<rubysspi>, [">= 1.3.1"])
    else
      s.add_dependency(%q<rubysspi>, [">= 1.3.1"])
    end
  else
    s.add_dependency(%q<rubysspi>, [">= 1.3.1"])
  end
end
