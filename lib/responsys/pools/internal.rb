# "Internal" pool. This is using the great ConnectionPool GEM.
#
# It's totally fine with one multi-threaded server but as you add more servers in a load-balanced infrastructure,
# there will be one ConnectionPool singleton per server.
# In that case, there will be multiple pools trying to access to Responsys
# which can end up having throttling and concurrent calls issues.
#
# To solve this, checkout the other type of connection pool available using Redis. The way it works is the same
# as the Redis one.
module Responsys
  module Pools
    class Internal
      ACCEPTED_SETTINGS = [:timeout, :size]

      def initialize
        settings = Responsys.configuration.settings[:connection_pool]
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
          yield(session)
        end
      end
    end
  end
end