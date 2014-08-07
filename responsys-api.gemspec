# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'responsys/api/version'

Gem::Specification.new do |spec|
  spec.name          = "responsys-api"
  spec.version       = Responsys::Api::VERSION
  spec.authors       = ["Dan DeMeyere", "Florian Lorrain", "Morgan Griggs", "Mike Rocco"]
  spec.email         = ["dan@thredup.com", "florain.lorrain@thredup.com", "morgan@thredup.com", "michael.rocco@thredup.com"]
  spec.description   = 'A gem to integrate with the Responsys SOAP API'
  spec.summary       = 'TODO: Write a proper summary'
  spec.homepage      = "https://github.com/dandemeyere/responsys-api"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
end
