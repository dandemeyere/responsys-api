require "logger"

module Responsys
  class Configuration
    attr_accessor :settings

    def initialize
      @settings = {}
    end

    def httparty_settings
      settings_hash = {
        format: :json,
        headers: {
          "Content-Type" => "application/json"
        }
      }

      @settings[:httparty_settings].merge(settings_hash)
    end

    def login_endpoint
      @settings[:login_endpoint]
    end

    def api_credentials
      {
        user_name: @settings[:username],
        password: @settings[:password],
        auth_type: "password"
      }
    end

    def debug!(to_debug_or_not_to_debug)
      @settings[:debug] = !!(to_debug_or_not_to_debug)
    end

    def disable!(to_disable_or_to_not_disable)
      @settings[:enabled] = !(to_disable_or_to_not_disable)
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
  end

  def self.disable!(to_disable_or_to_not_disable)
    @configuration.disable!(to_disable_or_to_not_disable)
  end

  def self.debug!(to_debug_or_not_to_debug)
    @configuration.debug!(to_debug_or_not_to_debug)
  end

  private

  def self.check_configuration
    raise Responsys::Exceptions::ConfigurationException.new("configuration.api_description_not_provided") if absent_api_description?
    raise Responsys::Exceptions::ConfigurationException.new("configuration.api_credentials_not_provided") if absent_api_credentials?
    raise Responsys::Exceptions::ConfigurationException.new("configuration.invalid_connection_pool_type") if incorrect_pool?
  end

  def self.prepare!
    @configuration.settings = default_settings_hash.deep_merge!(@configuration.settings)
    @configuration.settings[:httparty_settings].deep_merge!(httparty_settings)

    add_debug_options! if @configuration.debug?
  end

  def self.httparty_settings
    default_settings_hash[:httparty_settings].deep_merge!(@configuration.settings[:httparty_settings])
  end

  def self.add_debug_options!
    @configuration.settings[:httparty_settings].deep_merge!(debug_httparty_settings)
  end

  def self.debug_httparty_settings
    {
      logger: @configuration.settings[:httparty_settings][:logger] || ::Logger.new(STDOUT),
      log_level: :info,
      log_format: :curl
    }
  end

  def self.absent_api_description?
    @configuration.settings[:login_endpoint].blank?
  end

  def self.absent_api_credentials?
    @configuration.settings[:username].blank? || @configuration.settings[:password].blank?
  end

  def self.incorrect_pool?
    return if @configuration.settings[:connection_pool].blank?

    #Pool type
    (!@configuration.settings[:connection_pool][:type].blank? && @configuration.settings[:connection_pool][:type] != :internal && @configuration.settings[:connection_pool][:type] != :redis) ||

    #Pool settings
    (!@configuration.settings[:connection_pool][:size].blank? && !@configuration.settings[:connection_pool][:size].is_a?(Integer)) ||
    (!@configuration.settings[:connection_pool][:timeout].blank? && !@configuration.settings[:connection_pool][:timeout].is_a?(Integer)) ||

    #Redis settings
    (@configuration.settings[:connection_pool][:type] == :redis && (@configuration.settings[:connection_pool][:host].blank? ||
      @configuration.settings[:connection_pool][:port].blank? || !@configuration.settings[:connection_pool][:port].is_a?(Integer))
    )
  end

  def self.default_settings_hash
    {
      enabled: true,
      debug: false,
      connection_pool: { type: :internal, size: 80, timeout: 30 },
      httparty_settings: {}
    }
  end
end