# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "test-unit-fasterskip/version"

# This is so that Jenkins builds increment version number.
gem_version = Test::Unit::FasterSkip::VERSION.dup
if ENV.has_key?('BUILD_NUMBER')
  gem_version << ".#{ENV['BUILD_NUMBER']}"
end

Gem::Specification.new do |s|
  s.name        = "test-unit-fasterskip"
  s.version     = gem_version
  s.authors     = ["Jørgen P. Tjernø"]
  s.email       = ["jtjerno@mylookout.com"]
  s.homepage    = "https://github.com/jorgenpt/test-unit-fasterskip"
  s.summary     = %q{Add class-level pend & omit_if/unless that skips setup/teardown}
  s.description = %q{If you have very heavy-weight setup/teardown methods, this
  gem allows you to mark tests as pending or omitted on a class level. This will
  skip calling setup/teardown for that test, but still "pend"/"omit" it like
  normal.}

  s.rubyforge_project = "test-unit-fasterskip"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_runtime_dependency "test-unit", ">= 2.4.0"
end
