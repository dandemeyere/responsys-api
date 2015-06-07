module Responsys
  module Api
    class Resource
      %w(get post delete).each do |method|
        define_method(method.to_sym) { |*params| api_method(method.to_sym, *params) }
      end

      def initialize
        global_configuration = Responsys.configuration

        @login_endpoint = global_configuration.login_endpoint
        @credentials = global_configuration.api_credentials
        @httparty_settings = global_configuration.httparty_settings
      end

      private

      def api_method(http_method, path, params = nil, formatter = nil)
        unless Responsys.configuration.enabled?
          raise Responsys::Exceptions::DisabledException.new if Client.raise_exceptions
          return "disabled"
        end

        run(http_method, "#{resource_path}#{path}", params).format_with(formatter)
      end

      def authenticate!
        response = make_call(:post, @login_endpoint, "/rest/api/v1/auth/token", { query: @credentials })

        raise Responsys::Exceptions::FailedAuthentication.new(response.error_title) if response.error?

        Authentication.token = response.data[:authToken]
        Authentication.api_endpoint = response.data[:endPoint]
      end

      def refresh_token!
        response = make_call(:post, @login_endpoint, "/rest/api/v1/auth/token", { query: { auth_type: "token" } })

        raise Responsys::Exceptions::FailedAuthentication.new(response.error_title) if response.error?

        Authentication.token = response.data[:authToken]
        Authentication.api_endpoint = response.data[:endPoint]
      end

      def run(http_method, path, params)
        authenticate! unless Authentication.authenticated?

        settings = { headers: { "Authorization" => Authentication.token } }

        response = make_call(http_method, Authentication.api_endpoint, path, params.deep_merge(settings))

        if response.error? && response.error_code == "TOKEN_EXPIRED"
          refresh_token!
          response = run(http_method, path, params)
        end

        response
      end

      def make_call(http_method, endpoint, path, call_options)
        call_options[:body] = call_options[:body].to_json if call_options[:body]
        call_options = Responsys.configuration.httparty_settings.deep_merge(call_options)

        response = HTTParty.send(http_method.to_sym, "#{endpoint}#{path}", call_options)

        Responsys::Api::Response.new(response)
      end

      def resource_path
        raise Responsys::Exceptions::InternalException.new("api.resource.resource_path_not_implemented")
      end
    end
  end
end