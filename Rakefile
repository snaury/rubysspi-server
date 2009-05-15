require 'rubygems'
require 'rake/gempackagetask'
require 'rake/testtask'

spec = Gem::Specification.new do |s|
  s.platform = Gem::Platform::RUBY
  s.name = "rubysspi-server"
  s.version = "0.0.1"
  s.summary = "A library which implements Ruby server bindings to the Win32 SSPI library."

  s.add_dependency('rubysspi', '>= 1.3.1')
  s.files = FileList["lib/**/*", "*.txt", "Rakefile"].to_a
  s.require_path = "lib"

  s.author = "Alexey Borzenkov"
  s.email = "snaury@gmail.com"
  s.extra_rdoc_files = ["README.txt", "LICENSE.txt"]
  s.has_rdoc = true
end

Rake::GemPackageTask.new(spec) do |pkg|
  pkg.need_tar = true
end
