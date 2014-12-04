require "responsys/configuration"
require "savon"
require "responsys/api/all"
require "responsys/api/object/all"
require "singleton"

module Responsys
  module Api
    class Client
      include Singleton
      include Responsys::Api::All

      attr_accessor :credentials, :client, :session_id, :jsession_id, :header, :settings

      AVAILABLE_SETTINGS = Responsys::Helper.get_message("api.client.available_methods")

      def initialize
        @settings = Responsys.configuration.settings
        @credentials = {
          username: @settings[:username],
          password: @settings[:password]
        }

        @client = Savon.client(filtered_settings)
      end

      def api_method(action, message = nil)
        raise Responsys::Helper.get_message("api.client.api_method.wrong_action_#{action.to_s}") if action.to_sym == :login || action.to_sym == :logout

        begin
          login

          response = run_with_credentials(action, message, jsession_id, header)

          Responsys::Helper.format(action: action, response: response)

        rescue Exception => e
          Responsys::Helper.format(error: e)
        ensure
          logout
        end
      end

      def available_operations
        @client.operations
      end

      private

      def filtered_settings
        settings[:ssl_version] = :TLSv1 unless settings[:ssl_version]
        settings.select { |k,v| k.to_s != "username" && k.to_s != "password" && AVAILABLE_SETTINGS.include?(k.to_s) }
      end

      def run(method, message)
        @client.call(method.to_sym, message: message)
      end

      def run_with_credentials(method, message, cookie, header)
        @client.call(method.to_sym, message: message, cookies: cookie, soap_header: header)
      end
    end
  end
end