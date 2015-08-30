require "singleton"

module Responsys
  class SessionPool
    include Singleton
    attr_accessor :pool
    ACCEPTED_SETTINGS = [:timeout, :size]

    def initialize
      settings = Responsys.configuration.settings[:sessions]
      @params = if settings
        settings.select { |option, value| ACCEPTED_SETTINGS.include?(option) }
      else
        {}
      end

      renew!
    end

    def renew!
      @pool = ::ConnectionPool.new(@params) { Responsys::Session.new }
    end

    def with
      @pool.with do |session|
        yield session
      end
    end
  end
end