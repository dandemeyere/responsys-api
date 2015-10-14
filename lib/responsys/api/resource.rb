module Responsys
  module Api
    class Resource
      include Responsys::Exceptions
      include Responsys::Api::Object

      %w(get post delete).each do |method|
        define_method(method.to_sym) { |*params| api_method(method.to_sym, *params) }
      end

      def initialize
        global_configuration = Responsys.configuration

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

      def run(http_method, path, params)
        SessionPool.instance.with do |session|
          session.authenticate! unless session.authenticated?

          settings = { headers: { "Authorization" => session.token } }

          response = Resource.make_call(http_method, session.api_endpoint, path, params.deep_merge(settings))

          if response.error? && response.error_code == "TOKEN_EXPIRED"
            refresh_token!
            response = run(http_method, path, params)
          end

          response
        end
      end

      def self.make_call(http_method, endpoint, path, call_options)
        final_options = prepare_options(call_options)

        response = HTTParty.send(http_method.to_sym, "#{endpoint}#{path}", final_options)

        Responsys::Api::Response.new(response)
      end

      def self.prepare_options(call_options)
        merged_options = Responsys.configuration.httparty_settings.deep_merge!(call_options)

        if merged_options[:body] && json_content_type?(merged_options)
          merged_options[:body] = merged_options[:body].to_json
        end

        merged_options
      end

      def self.json_content_type?(call_options)
        call_options[:headers]["Content-Type"] == "application/json"
      end

      def resource_path
        raise Responsys::Exceptions::InternalException.new("api.resource.resource_path_not_implemented")
      end
    end
  end
end
