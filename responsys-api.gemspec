# coding: utf-8
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |spec|
  spec.name          = "responsys-api"
  spec.version       = "0.3.0"
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

  spec.required_ruby_version = '>= 2.1.0'

  spec.add_dependency "rubyntlm", "0.4.0"
  spec.add_dependency "savon", "2.10.1"
  spec.add_dependency "wasabi", "3.4.0"
  spec.add_dependency "i18n", ">= 0.6.9", "<= 0.7.0"
  spec.add_dependency "connection_pool", "~> 2.2.1"
  spec.add_dependency "public_suffix", "<= 1.4.6"
  spec.add_dependency "nokogiri", "<= 1.8.0"

  # Ruby 1.9 compatibility
  spec.add_development_dependency "rack", "~> 1.6.4"
  spec.add_development_dependency "json", "~> 1.8.3"
  spec.add_development_dependency "tins", "~> 1.6.0"
  spec.add_development_dependency "term-ansicolor", "~> 1.3.2"

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake", "~> 10.3"
  spec.add_development_dependency "rspec", "~> 3.2"
  spec.add_development_dependency "vcr", "~> 2.9"
  spec.add_development_dependency "webmock", "~> 1.9"
  spec.add_development_dependency "coveralls", "~> 0.8.1"
end
