# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'siriproxy-sancho/version'

Gem::Specification.new do |gem|
  gem.name          = "siriproxy-sancho"
  gem.version       = Siriproxy::Sancho::VERSION
  gem.authors       = ["崔峥"]
  gem.email         = ["zheng.cuizh@gmail.com"]
  gem.description   = %q{just a siriproxy plugin for myself}
  gem.summary       = %q{nothing}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_runtime_dependency "eventmachine"
  gem.add_runtime_dependency "em-http-request"
  gem.add_runtime_dependency "uuid"
end
