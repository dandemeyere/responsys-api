require "bundler/setup"
Bundler.setup

require "responsys_api.rb"
require "vcr"
require "yaml"
require "pathname"
require "spec_support.rb"
require "uri"

DATA = YAML.load_file("#{File.dirname(__FILE__)}/test_data.yml")
DEBUG = true
CREDENTIALS = get_credentials

VCR.configure do |c|
  c.cassette_library_dir = "spec/fixtures/vcr_cassettes"
  c.hook_into :webmock
  c.filter_sensitive_data("your_responsys_username") { URI.encode_www_form_component(CREDENTIALS["username"]) }
  c.filter_sensitive_data("your_responsys_password") { URI.encode_www_form_component(CREDENTIALS["password"]) }
  c.before_record do |c|
    c.request.headers["Authorization"] = ["AUTH_TOKEN"] if c.request.headers["Authorization"]
    c.response.body.sub!(/"authToken":".*",/, "\"authToken\":\"AUTH_TOKEN\",")
  end
end

RSpec.configure do |config|
  config.before(:example, i18n_test_files: true) do
    #Set the use of i18n test files.
    toggle_i18n_test_files(true)
  end

  config.after(:example, i18n_test_files: true) do
    #Reset the use of i18n test files.
    toggle_i18n_test_files(false)
  end

  config.after(:each) do |test|
    #By default, destroy the previous session object in the pool after each test.
    #We want to force a new authentication in each unit test / VCR cassette
    Responsys::SessionPool.instance.renew! unless !!(test.metadata[:stay_logged_in])
  end
end

##In spec_support.rb
##Use the credentials of your account that must be present in spec/api_credentials.yml (copy of api_credentials.sample.yml)
configure_gem
