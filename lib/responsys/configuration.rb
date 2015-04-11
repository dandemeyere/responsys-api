module Responsys
  class Configuration
    include Responsys::Exceptions

    attr_accessor :settings

    def initialize
      @settings = {}
    end

    def savon_settings
      raise GenericException.new("A WSDL or endpoint is needed.") if absent_api_description?

      default_savon_settings
        .merge!(@settings[:savon_settings])
        .merge!(savon_api_description)
    end

    def api_credentials
      {
        username: @settings[:username],
        password: @settings[:password]
      }
    end

    def savon_api_description
      if !@settings[:wsdl].blank?
        { wsdl: @settings[:wsdl] }
      else
        {
          endpoint: @settings[:endpoint],
          namespace: @settings[:namespace]
        }
      end
    end

    private

    def absent_api_description?
      wsdl = !@settings[:wsdl].blank?
      endpoint = !@settings[:endpoint].blank?
      namespace = !@settings[:namespace].blank?

      return false if wsdl

      return !(endpoint && namespace) if endpoint || namespace

      true
    end

    def default_savon_settings
      settings = { ssl_version: :TLSv1, element_form_default: :qualified }

      if @settings[:debug]
        settings.merge!(savon_debug_settings)
      else
        settings
      end
    end

    def savon_debug_settings
      { log_level: :debug, log: true, pretty_print_xml: true }
    end
  end

  class << self
    attr_accessor :configuration
  end

  def self.configuration
    @configuration ||= Configuration.new
  end

  def self.configure
    yield(configuration)

    @configuration.settings.merge!(default_settings_hash)

    Responsys::Api::SessionPool.init
  end

  private

  def self.default_settings_hash
    {
      debug: false,
      sessions: {
        size: 80,
        timeout: 30
      },
      savon_settings: {}
    }
  end
end