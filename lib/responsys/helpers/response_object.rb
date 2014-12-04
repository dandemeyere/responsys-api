module Responsys
  class ResponseObject
    attr_accessor :response_hash

    def initialize(response)
      raise ParameterException, "The parameter is not a hash" unless response.is_a?(Hash)
      @response_hash = response
    end

    def success?
      response_hash[:success] == true
    end

    def error?
      response_hash[:success] == false
    end

    def error_code
      return nil unless error?

      "#{response_hash[:error][:code]}"
    end

    def error_message
      return nil unless error?

      "#{response_hash[:error][:message]}"
    end

    def error_desc
      "#{error_code} - #{error_message}"
    end

    def data
      if @response_hash.has_key?(:data)
        @response_hash[:data]
      elsif @response_hash.has_key?(:result)
        @response_hash[:result]
      else
        nil
      end
    end
  end
end