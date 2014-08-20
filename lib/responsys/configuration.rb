module Responsys
  class Configuration
    attr_accessor :settings

    def initialize
      @settings = {
        username: nil,
        password: nil,
        wsdl: "",
        debug: false
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
  end
end
