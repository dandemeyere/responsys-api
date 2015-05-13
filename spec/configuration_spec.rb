# encoding: UTF-8

require "spec_helper.rb"

describe Responsys::Configuration do
  def valid_configuration
    Responsys.configure do |config|
      config.settings = {
        wsdl: "http://file.wsdl",
        username: "username",
        password: "password",
        debug: false
      }
    end
  end

  def valid_configuration_with_endpoint
    Responsys.configure do |config|
      config.settings = {
        endpoint: "http://endpoint",
        namespace: "http://namespace",
        username: "username",
        password: "password",
        debug: false,
        sessions: {
          size: 50
        }
      }
    end
  end

  def valid_configuration_with_savon_settings
    Responsys.configure do |config|
      config.settings = {
        wsdl: "http://file.wsdl",
        username: "username",
        password: "password",
        debug: false,
        savon_settings: {
          open_timeout: 420,
          read_timeout: 420
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

  def no_api_credentials_configuration
    Responsys.configure do |config|
      config.settings = {
        wsdl: "http://file.wsdl",
        debug: false
      }
    end
  end

  def gem_is_disabled
    Responsys.configure do |config|
      config.settings = {
        wsdl: "http://file.wsdl",
        username: "username",
        password: "password",
        enabled: false
      }
    end
  end

  describe "#configure" do
    it "should raise an exception if no api description is provided" do
      expect{ no_api_desc_configuration }.to raise_error(Responsys::Exceptions::GenericException, "A WSDL or endpoint+namespace is needed.")
    end

    it "should raise an exception if no api credentials are provided" do
      expect{ no_api_credentials_configuration }.to raise_error(Responsys::Exceptions::GenericException, "No credentials are provided in the configuration.")
    end    
  end

  describe "#savon_settings" do
    it "should build the settings hash with a wsdl" do
      valid_configuration_with_savon_settings

      expect(Responsys.configuration.savon_settings).to eq(
        {
          wsdl: "http://file.wsdl",
          ssl_version: :TLSv1, 
          element_form_default: :qualified,
          open_timeout: 420,
          read_timeout: 420
        }
      )
    end

    it "should build the settings hash with an endpoint+namespace" do
      valid_configuration_with_endpoint

      expect(Responsys.configuration.savon_settings).to eq(
        {
          endpoint: "http://endpoint",
          namespace: "http://namespace",
          ssl_version: :TLSv1, 
          element_form_default: :qualified
        }
      )
    end
  end

  describe "#session_settings" do
    it "should build the correct values" do
      valid_configuration_with_endpoint

      expect(Responsys.configuration.session_settings).to eq(
        {
          size: 50,
          timeout: 30
        }
      )
    end
  end
  
  describe "#api_credentials" do
    it "should be correct!" do
      valid_configuration

      expect(Responsys.configuration.api_credentials).to eq(
        {
          username: "username",
          password: "password"
        }
      )
    end
  end

  it "should correctly build the savon settings with the default settings" do
    valid_configuration_with_savon_settings

    expect(Responsys.configuration.settings).to eq(
      {
        enabled: true,
        wsdl: "http://file.wsdl",
        username: "username",
        password: "password",
        debug: false,
        savon_settings: {
          open_timeout: 420,
          read_timeout: 420,
          ssl_version: :TLSv1, 
          element_form_default: :qualified
        },
        sessions: { size: 80, timeout: 30 }
      }
    )
  end
end