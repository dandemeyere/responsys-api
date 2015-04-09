module Responsys
  module Api
    class Client
      include Responsys::Api::All
      attr_accessor :client

      #TODO allows to keep the use of .instance. The client is no longer a singleton so it needs to be removed in a newer release.
      class << self
        alias :instance :new
      end

      def api_method(action, message = nil)
        raise Responsys::Helpers.get_message("api.client.api_method.wrong_action_#{action.to_s}") if action.to_sym == :login || action.to_sym == :logout

        SessionPool.instance.with do |session|
          begin
            session.login

            response = session.run_with_credentials(action, message)

            Responsys::Helpers.format(action: action, response: response)

          rescue Exception => e
            Responsys::Helpers.format(error: e)
          ensure
            session.logout
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