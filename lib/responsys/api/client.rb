require 'responsys/configuration'
require 'savon'
require 'responsys/helper'
require 'responsys/api/all'
require 'responsys/api/object/all'

module ResponsysApi
  module Api
    class Client
      include ResponsysApi::Api::All
      attr_accessor :credentials, :client, :session_id, :jsession_id, :header
      
      def initialize
        settings = ResponsysApi.configuration.settings
        @credentials = {
          "username" => settings[:username],
          "password" => settings[:password]
        }
        
        #@client = Savon.client(log_level: :debug, log: true, pretty_print_xml: true, wsdl: settings[:wsdl], element_form_default: :qualified)
        # should use this, the call above is only to help debug
        @client = Savon.client(wsdl: settings[:wsdl], element_form_default: :qualified)
        login
      end

      def api_method(action, message = nil)
        response = run_with_credentials(action, message, jsession_id, header)
        ResponsysApi::Helper.format_response(response, action)
      end

      def available_operations
        @client.operations
      end

      private
      def run(method, message)
        @client.call(method.to_sym, message: message)
      end

      def run_with_credentials(method, message, cookie, header)
        @client.call(method.to_sym, message: message, cookies: cookie, soap_header: header)
      end
    end
  end
end