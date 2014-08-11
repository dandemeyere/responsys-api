module ResponsysApi
  class Configuration
    attr_accessor :settings

    def initialize
      @settings = {
        username: nil,
        password: nil,
        wsdl: ""
      }
    end
  end

  class << self
    attr_accessor :configuration
  end

  # Initiate the configuration
  def self.configuration
    @configuration ||= Configuration.new
  end

  # Display the configuration of the client
  def self.configure
    yield(configuration)
  end
end
