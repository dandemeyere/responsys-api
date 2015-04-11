module Responsys
  module Api
    class Session
      attr_accessor :credentials, :session_id, :jsession_id, :header
      include Responsys::Api::Authentication

      def initialize
        global_configuration = Responsys.configuration

        @credentials = global_configuration.api_credentials
        @savon_client = Savon.client(global_configuration.savon_settings)
      end

      def run(method, message)
        @savon_client.call(method.to_sym, message: message)
      end

      def run_with_credentials(method, message)
        @savon_client.call(method.to_sym, message: message, cookies: jsession_id, soap_header: header)
      end
    end
  end
end