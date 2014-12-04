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

VCR.configure do |c|
  c.cassette_library_dir = "spec/fixtures/vcr_cassettes"
  c.hook_into :webmock
  c.filter_sensitive_data("your_responsys_username") { CREDENTIALS["username"] }
  c.filter_sensitive_data("your_responsys_password") { CREDENTIALS["password"] }
  c.default_cassette_options = { match_requests_on: [:method, :uri, :body] }
  c.before_record do |c|
    c.request.headers = nil
    c.response.headers = nil
    c.request.body.sub!(/<sessionId>.*<\/sessionId>/, "<sessionId>DEAR_SESSION_ID</sessionId>")
    c.response.body.sub!(/<sessionId>.*<\/sessionId>/, "<sessionId>DEAR_SESSION_ID</sessionId>")
  end
end

Responsys.configure do |config|
  config.settings = {
    username: CREDENTIALS["username"],
    password: CREDENTIALS["password"],
    wsdl: CREDENTIALS["wsdl"],
    element_form_default: :qualified
  }
end