# Connection pool based on Redis objects.
#
# The idea is to have one Redis shared between different possible
# instances of the GEM (i.e more than one server).
#
# The params to pass in the "connection_pool" config key are:
#   - host
#   - port
#   - password (optional)
#
# The implementation needs two Redis objects:
#   - a List (the key is LIST_AVAILABLE): used as a FIFO. The List is initialized the first time (renew!)
#     with elements representing available connections (equals to the :size setting).
#   - a Hash (the key is HASH_PENDING): used to keep track of currently used sessions.
#   The Hash is empty by default.
#
# Typical scenario:
#   1) A resource (List, Event, ...) needs a session. It calls SessionPool.instance.with with a block. The singleton passes it
#   to the with method down here.
#
#   2) The pool takes or waits for an available slot in the List. It is instant unless all sessions are used.
#   In that case, the thread is blocked until one comes available. If it's too long, the
#   GEM raises a Timeout exception (value specified in the settings).
#
#   3) Moves the session to HASH_PENDING. The Hash key is the UUID of the session object. The session data
#   is unserialized (UUID, token, login_endpoint, api_endpoint).
#
#   4) The resource runs the call on the Responsys::Session. If the existing token saved in the object
#   needs to be refreshed, it will be replaced by a new one.
#
#   5) The Session is moved back to the LIST_AVAILABLE with its data.
#   The element in the HASH_PENDING is removed first, updated and put in LIST_AVAILABLE for another call.
require "timeout"

module Responsys
  module Pools
    class Redis
      REDIS_CONNECTION_SETTINGS = [:host, :port, :password]
      ACCEPTED_SETTINGS = [:timeout, :size] | REDIS_CONNECTION_SETTINGS
      LIST_AVAILABLE = "available"
      HASH_PENDING = "pending"

      attr_accessor :connection

      def initialize
        settings = Responsys.configuration.settings[:connection_pool]
        @params = if settings
          settings.select { |option, value| ACCEPTED_SETTINGS.include?(option) }
        else
          {}
        end

        #raise if no timeout/size

        connect!
        renew!
      end

      # The Li
      def renew!
        begin
          @connection.multi

          @connection.del(LIST_AVAILABLE)
          @connection.del(HASH_PENDING)

          @connection.lpush(LIST_AVAILABLE, (1..@params[:size]).map { |_| Responsys::Session.new.to_json })

          @connection.exec
        rescue Exception => e
          @connection.discard
          raise e
        end
      end

      def with
        # Reserves a session in the pool
        session = reserve!

        # Runs the call with that session. Reuse the existing token if any.
        response = yield(session)

        # Persists the session back into the List. If the token has been updated
        # because it expired then it will be saved here too.
        release!(session)

        # Returns the API response.
        response
      end

      private

      def connect!
        redis_connection = ::Redis.new(@params.select { |key, _| REDIS_CONNECTION_SETTINGS.include?(key) })
        @connection = ::Redis::Namespace.new(:responsys_api, redis: redis_connection)
      end

      def reserve!
        # Blocks until a session is available
        session_data = @connection.blpop(LIST_AVAILABLE, timeout: @params[:timeout])

        # If timed out (first element is nil), let's raise an exception.
        raise Responsys::Exceptions::TimeOutException if session_data[0].nil?

        # Save the session before it's used in the pending hash.
        @connection.hset(HASH_PENDING, session_data[1]["uuid"], session_data[1])

        # Build a Session object from the data that was in Redis.
        Responsys::Session.from_json(session_data[1])
      end

      def release!(session)
        # All the calls are wrapped in a transaction (multi-exec)
        begin
          # Transaction start
          @connection.multi

          # Serialize the Session instance.
          session_data = session.to_json

          # Removes the object from the pending hash. The UUID is used to look it up.
          @connection.hdel(HASH_PENDING, session_data["uuid"])

          # The connection is made available for a future call.
          @connection.lpush(LIST_AVAILABLE, session_data)

          # Runs all at once.
          @connection.exec
        rescue Exception => e
          # If one of the previous call fails, let's discard everything and raise the exception.
          @connection.discard
          raise e
        end
      end
    end
  end
end