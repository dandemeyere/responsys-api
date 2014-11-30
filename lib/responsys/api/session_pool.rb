require "singleton"

module Responsys
  module Api
    class SessionPool
      include Singleton
      attr_accessor :pool
      ACCEPTED_SETTINGS = [:timeout, :size]

      class << self
        alias :init :instance
      end

      def initialize
        settings = Responsys.configuration.settings[:sessions]
        params = if settings
          settings.select { |option, value| ACCEPTED_SETTINGS.include?(option) }
        else
          {}
        end

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