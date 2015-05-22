module Responsys
  module Api
    class Client
      include Responsys::Api::All
      include Responsys::Exceptions
      attr_accessor :client

      #TODO allows to keep the use of .instance. The client is no longer a singleton so it needs to be removed in a newer release.
      class << self
        alias :instance :new
      end

      def initialize
        @raise_exceptions = false
      end

      def api_method(action, message = nil, response_type = :hash)
        raise ParameterException.new("api.client.api_method.wrong_action_#{action.to_s}") if action.to_sym == :login || action.to_sym == :logout

        unless Responsys.configuration.enabled?
          raise DisabledException.new if @raise_exceptions
          return "disabled"
        end

        SessionPool.instance.with do |session|
          begin
            session.login
            response = session.run_with_credentials(action, message)
            session.logout
            case response_type
            when :result
             Responsys::Helper.format_response_result(response, action)
            when :hash
             Responsys::Helper.format_response_hash(response, action)
            else
             response
            end
          rescue Exception => e
            Responsys::Helper.format_response_with_errors(e)
          end
        end
      end

      def run(exception_raising = false)
        old_raise_exceptions = @raise_exceptions
        @raise_exceptions = exception_raising
        begin
          yield(self)
        rescue DisabledException => e
          raise e if @raise_exceptions
          return "disabled"
        ensure
          @raise_exceptions = old_raise_exceptions
        end
      end

      def available_operations
        SessionPool.instance.with do |session|
          session.operations
        end
      end
    end
  end
end
