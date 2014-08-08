class ResponsysApi
  class Configuration
    attr_accessor :settings
    # Put all these constants into a configurable setting hash

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

  def self.configuration
    @configuration ||= Configuration.new
  end

  def self.configure
    yield(configuration)
  end
end
