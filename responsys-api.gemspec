# coding: utf-8
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |spec|
  spec.name          = "responsys-api"
  spec.version       = "0.2.4"
  spec.authors       = ["Dan DeMeyere", "Florian Lorrain", "Morgan Griggs", "Mike Rocco"]
  spec.email         = ["dan@thredup.com", "florian.lorrain@thredup.com", "morgan@thredup.com", "michael.rocco@thredup.com"]
  spec.description   = "A gem to integrate with the Responsys SOAP API"
  spec.summary       = "See the github repository for further information about the usage and the needed configuration"
  spec.homepage      = "https://github.com/dandemeyere/responsys-api"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.required_ruby_version = '>= 1.9.3'

  spec.add_dependency "rubyntlm", "0.4.0"
  spec.add_dependency "savon", "2.10.1"
  spec.add_dependency "wasabi", "3.4.0"
  spec.add_dependency "i18n", "~> 0.7"
  spec.add_dependency "connection_pool", "2.1.3"
  spec.add_development_dependency "bundler", "~> 1.9"
  spec.add_development_dependency "rake", "~> 10.3"
  spec.add_development_dependency "rspec", "~> 3.2"
  spec.add_development_dependency "vcr", "~> 2.9"
  spec.add_development_dependency "webmock", "~> 1.9"
  spec.add_development_dependency "coveralls", "~> 0.8.1"
end
