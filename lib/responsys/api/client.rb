require "responsys/configuration"
require "savon"
require "responsys/helper"
require "responsys/api/all"
require "responsys/api/object/all"
require "singleton"

module Responsys
  module Api
    class Client
      include Singleton
      include Responsys::Api::All

      attr_accessor :credentials, :client, :session_id, :jsession_id, :header, :settings

      AVAILABLE_SETTINGS = %w(wsdl endpoint namespace raise_errors proxy headers open_timeout
        read_timeout ssl_verify_mode ssl_version ssl_cert_file ssl_cert_key_file
        ssl_ca_cert_file ssl_cert_key_password convert_request_keys_to soap_header element_form_default
        env_namespace namespace_identifier namespaces encoding soap_version
        basic_auth digest_auth wsse_auth wsse_timestamp ntlm strip_namespaces convert_response_tags_to
        logger log_level log filters pretty_print_xml)

      def initialize
        @settings = Responsys.configuration.settings
        @credentials = {
          username: @settings[:username],
          password: @settings[:password]
        }

        @client = Savon.client(filtered_settings)
      end

      def api_method(action, message = nil, response_type = :hash)
        raise Responsys::Helper.get_message("api.client.api_method.wrong_action_#{action.to_s}") if action.to_sym == :login || action.to_sym == :logout

        begin
          login

          response = run_with_credentials(action, message, jsession_id, header)

          case response_type
          when :result
            Responsys::Helper.format_response_result(response, action)
          when :hash
            Responsys::Helper.format_response_hash(response, action)
          end

        rescue Exception => e
          Responsys::Helper.format_response_with_errors(e)
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