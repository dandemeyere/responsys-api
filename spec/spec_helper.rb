require "bundler/setup"
Bundler.setup

require "responsys_api.rb"
require "vcr"

VCR.configure do |c|
  c.cassette_library_dir = "spec/fixtures/vcr_cassettes"
  c.hook_into :webmock
end

Responsys.configure do |config|
  config.settings = {
    username: "your_responsys_username",
    password: "your_responsys_password",
    wsdl: "https://wsxxxx.responsys.net/webservices/wsdl/ResponsysWS_Level1.wsdl",
    debug: false
  }
end

# Responsys.configure do |config|
#   config.settings = {
#     username: "your_responsys_username",
#     password: "your_responsys_password",
#     wsdl: "https://wsxxxx.responsys.net/webservices/wsdl/ResponsysWS_Level1.wsdl",
#     debug: false
#   }
# end

I18n.enforce_available_locales = false