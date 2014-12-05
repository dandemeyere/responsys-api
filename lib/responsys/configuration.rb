module Responsys
  class Configuration
    attr_accessor :settings

    def initialize
      @settings = {
        username: nil,
        password: nil,
        wsdl: "",
        debug: false,
        sessions: {
          size: 80,
          timeout: 30
        }
      }
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
    Responsys::Api::SessionPool.init
  end
end