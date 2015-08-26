module Responsys
  module Api
    class Client
      include Responsys::Api::All
      attr_accessor :client

      #TODO allows to keep the use of .instance. The client is no longer a singleton so it needs to be removed in a newer release.
      class << self
        alias :instance :new
      end

      def api_method(action, message = nil, response_type = :hash)
        raise Responsys::Helper.get_message("api.client.api_method.wrong_action_#{action.to_s}") if action.to_sym == :login || action.to_sym == :logout

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

      def available_operations
        SessionPool.instance.with do |session|
          session.operations
        end
      end
    end
  end
end

