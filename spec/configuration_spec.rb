# encoding: UTF-8

require "spec_helper.rb"

describe Responsys::Configuration do
  after(:all) do
    set_correct_credentials
  end

  def valid_configuration
    Responsys.configure do |config|
      config.settings = {
        login_endpoint: "https://login.net",
        username: "username",
        password: "password",
        debug: false
      }
    end
  end

  def valid_configuration_with_sessions
    Responsys.configure do |config|
      config.settings = {
        login_endpoint: "https://login.net",
        username: "username",
        password: "password",
        debug: false,
        sessions: {
          size: 50
        }
      }
    end
  end

  def valid_configuration_with_httparty_settings
    Responsys.configure do |config|
      config.settings = {
        login_endpoint: "https://login.net",
        username: "username",
        password: "password",
        debug: false,
        httparty_settings: {
          # open_timeout: 420,
          # read_timeout: 420
        }
      }
    end
  end

  def no_api_desc_configuration
    Responsys.configure do |config|
      config.settings = {
        username: "username",
        password: "password",
        debug: false
      }
    end
  end

  def incorrect_pool_configuration
    Responsys.configure do |config|
      config.settings = {
        login_endpoint: "https://login.net",
        username: "username",
        password: "password",
        connection_pool: { timeout: "10", size: 50, type: :redis },
        debug: false
      }
    end
  end

  def no_api_credentials_configuration
    Responsys.configure do |config|
      config.settings = {
        login_endpoint: "https://login.net",
        debug: false
      }
    end
  end

  def gem_is_disabled
    Responsys.configure do |config|
      config.settings = {
        login_endpoint: "https://login.net",
        username: "username",
        password: "password",
        enabled: false
      }
    end
  end

  describe "#configure" do
    it "should raise an exception if no api description is provided" do
      expect{ no_api_desc_configuration }.to raise_error(Responsys::Exceptions::ConfigurationException, "A login endpoint is needed.")
    end

    it "should raise an exception if no api credentials are provided" do
      expect{ no_api_credentials_configuration }.to raise_error(Responsys::Exceptions::ConfigurationException, "No credentials are provided in the configuration.")
    end

    it "should raise an exception if the connection pool has an incorrect configuration" do
      expect{ incorrect_pool_configuration }.to raise_error(Responsys::Exceptions::ConfigurationException, "Connection Pool settings are invalid.")
    end
  end

  describe "#savon_settings" do
    it "should build the settings hash with a wsdl" do
      valid_configuration_with_httparty_settings

      expect(Responsys.configuration.httparty_settings).to eq(
        {
          format: :json,
          headers: {
            "Content-Type" => "application/json"
          }
          # wsdl: "http://file.wsdl",
          # ssl_version: :TLSv1,
          # element_form_default: :qualified,
          # open_timeout: 420,
          # read_timeout: 420
        }
      )
    end

    it "should build the settings hash with an endpoint+namespace" do
      valid_configuration_with_sessions

      expect(Responsys.configuration.httparty_settings).to eq(
        {
          format: :json,
          headers: {
            "Content-Type" => "application/json"
          }
          # login_endpoint: "https://login.net",
          # ssl_version: :TLSv1,
          # element_form_default: :qualified
        }
      )
    end
  end

  describe "#api_credentials" do
    it "should be correct!" do
      valid_configuration

      expect(Responsys.configuration.api_credentials).to eq(
        {
          user_name: "username",
          password: "password",
          auth_type: "password"
        }
      )
    end
  end

  it "should correctly build the savon settings with the default settings" do
    valid_configuration_with_httparty_settings

    expect(Responsys.configuration.settings).to eq(
      {
        enabled: true,
        login_endpoint: "https://login.net",
        username: "username",
        password: "password",
        debug: false,
        connection_pool: {
          type: :internal,
          size: 80,
          timeout: 30
        },
        httparty_settings: {
          # open_timeout: 420,
          # read_timeout: 420,
          # ssl_version: :TLSv1,
          # element_form_default: :qualified
        }
      }
    )
  end
end