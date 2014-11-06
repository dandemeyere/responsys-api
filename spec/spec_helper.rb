require "bundler/setup"
Bundler.setup

require "responsys_api.rb"
require "vcr"
require "yaml"

if File.exist?("#{File.dirname(__FILE__)}/api_credentials.yml")
  CREDENTIALS = YAML.load_file("#{File.dirname(__FILE__)}/api_credentials.yml")
else
  CREDENTIALS = YAML.load_file("#{File.dirname(__FILE__)}/api_credentials.sample.yml")
end

DATA = YAML.load_file("#{File.dirname(__FILE__)}/test_data.yml")
IGNORE_LOGIN_REQUEST = true
IGNORE_LOGOUT_REQUEST = true

VCR.configure do |c|
  c.cassette_library_dir = "spec/fixtures/vcr_cassettes"
  c.hook_into :webmock
  c.ignore_request do |request|
    if request.to_hash["body"]["string"].empty?
      true
    else
      ignoring = false
      
      if IGNORE_LOGIN_REQUEST
        ignoring |= !Nokogiri::XML(request.to_hash["body"]["string"]).remove_namespaces!.xpath('/Envelope/Body/login', ).empty?
      end

      if IGNORE_LOGOUT_REQUEST
        ignoring |= !Nokogiri::XML(request.to_hash["body"]["string"]).remove_namespaces!.xpath('/Envelope/Body/logout', ).empty?
      end

      ignoring
    end
  end
end

Responsys.configure do |config|
  config.settings = {
    username: CREDENTIALS["username"],
    password: CREDENTIALS["password"],
    wsdl: CREDENTIALS["wsdl"],
    debug: false
  }
end

I18n.enforce_available_locales = false