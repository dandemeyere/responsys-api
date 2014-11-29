require "singleton"

module Responsys
  module Api
    class SessionPool
      include Singleton

      def initialize
        settings = Responsys.configuration.settings[:sessions]

        params = {}
        params.merge(settings) if settings

        @pool = ConnectionPool.new(params) { Responsys::Api::Session.new }
      end

      def with
        @pool.with do |session|
          yield session
        end
      end
    end
  end
end