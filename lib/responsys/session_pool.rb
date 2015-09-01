require "singleton"

module Responsys
  class SessionPool
    include Singleton
    attr_reader :pool, :type

    def initialize
      type = Responsys.configuration.settings[:connection_pool][:type]

      @type = Responsys::Pools::const_get(type.to_s.capitalize)

      renew!
    end

    def renew!
      @pool = @type.new
    end

    def with
      renew! unless @pool

      @pool.with do |session|
        yield(session)
      end
    end
  end
end