module Responsys
  class Configuration
    attr_accessor :settings

    def initialize
      @settings = {}
    end

    def savon_settings
      settings_hash = if @settings[:wsdl].present?
        { wsdl: @settings[:wsdl] }
      else
        {
          endpoint: @settings[:endpoint],
          namespace: @settings[:namespace]
        }
      end

      @settings[:savon_settings].merge(settings_hash)
    end

    def api_credentials
      {
        username: @settings[:username],
        password: @settings[:password]
      }
    end

    def session_settings
      @settings[:sessions]
    end

    def debug?
      !!(@settings[:debug])
    end

    def enabled?
      !!(@settings[:enabled])
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

    check_configuration

    prepare!

    Responsys::Api::SessionPool.init
  end

  private

  def self.check_configuration
    raise Responsys::Exceptions::GenericException.new("configuration.api_description_not_provided") if absent_api_description?
    raise Responsys::Exceptions::GenericException.new("configuration.api_credentials_not_provided") if absent_api_credentials?
  end

  def self.prepare!
    @configuration.settings = default_settings_hash.merge(@configuration.settings)
    @configuration.settings[:savon_settings] = savon_settings
    @configuration.settings[:sessions] = sessions

    add_debug_options! if @configuration.debug?
  end

  def self.savon_settings
    default_settings_hash[:savon_settings].merge!(@configuration.settings[:savon_settings])
  end

  def self.sessions
    default_settings_hash[:sessions].merge!(@configuration.settings[:sessions])
  end

  def self.add_debug_options!
    @configuration.settings[:savon_settings] = debug_savon_options.merge!(@configuration.settings[:savon_settings])
  end

  def self.debug_savon_options
    { log_level: :debug, log: true, pretty_print_xml: true }
  end

  def self.absent_api_description?
    wsdl = @configuration.settings[:wsdl].present?
    endpoint = @configuration.settings[:endpoint].present?
    namespace = @configuration.settings[:namespace].present?

    return false if wsdl

    return !(endpoint && namespace) if endpoint || namespace

    true
  end

  def self.absent_api_credentials?
    @configuration.settings[:username].blank? || @configuration.settings[:password].blank?
  end

  def self.default_settings_hash
    {
      enabled: true,
      debug: false,
      sessions: {
        size: 80,
        timeout: 30
      },
      savon_settings: {
        ssl_version: :TLSv1,
        element_form_default: :qualified
      }
    }
  end
end