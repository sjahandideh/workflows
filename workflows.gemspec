# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'workflows/version'

Gem::Specification.new do |spec|
  spec.name          = "workflows"
  spec.version       = Workflows::VERSION
  spec.authors       = ["Shamim"]
  spec.email         = ["shamim.jahandideh@gmail.com"]

  spec.summary       = %q{Organising multi-step functionalities into workflows.}
  spec.description   = %q{Creating a workflow class that organises and supervises micro-services.}
  spec.homepage      = "https://github.com/sjahandideh/workflows"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "pry"
  spec.add_development_dependency "pry-byebug"
end
