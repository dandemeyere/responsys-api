module Responsys
  module Api
    class Response
      attr_reader :httparty_response
      attr_reader :original_data
      attr_reader :formatted_data

      def initialize(httparty_response)
        raise ::Responsys::Exceptions::ParameterException.new("api.response.param_not_httparty") unless httparty_response.class == ::HTTParty::Response

        @httparty_response = httparty_response
        @formatted_data = nil
      end

      def success?
        @httparty_response.code.between?(200, 299)
      end

      def error?
        !success?
      end

      def data
        return @formatted_data if @formatted_data
        @original_data ||= parsed_body
      end

      def error_type
        return nil unless error?

        self.data[:type]
      end

      def error_title
        return nil unless error?

        self.data[:title]
      end

      def error_code
        return nil unless error?

        self.data[:errorCode]
      end

      def error_detail
        return nil unless error?

        self.data[:detail]
      end

      def error_details
        return nil unless error?

        self.data[:errorDetails]
      end

      def error_desc
        "#{error_code} - #{error_title}"
      end

      def format_with(klass)
        if success? && klass.is_a?(Class) && klass.respond_to?(:format)
          @formatted_data = klass.format(self.data)
        end
        self
      end

      private

      def parsed_body
        JSON.parse(@httparty_response.body, symbolize_names: true) || {}
      end
    end
  end
end