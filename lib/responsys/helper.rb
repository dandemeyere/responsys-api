module Responsys
  module Helper
    def self.format_response_result(response, action)
      response.body[("#{action}_response").to_sym][:result]
    end

    def self.format_response_hash(response, action)
      formatted_response = { status: "ok" }

      return formatted_response unless response.body.has_key? "#{action}_response".to_sym

      if response.body["#{action}_response".to_sym][:result].is_a? Hash
        formatted_response[:data] = handle_response_types(response.body["#{action}_response".to_sym])
      else
        formatted_response[:result] = response.body["#{action}_response".to_sym][:result]
      end

      formatted_response
    end

    def self.handle_response_types(response_body)
      data = []

      if response_body[:result].has_key? :record_data
        field_names = response_body[:result][:record_data][:field_names]

        if response_body[:result][:record_data][:records].is_a? Array

          response_body[:result][:record_data][:records].each do |record|
            values = {}

            record[:field_values].each_with_index do | value, index |
              values[field_names[index].to_sym] = value
            end

            data << values
          end

        else
          values = {}

          if response_body[:result][:record_data][:records][:field_values].is_a? Array
            response_body[:result][:record_data][:records][:field_values].each_with_index do | value, index |
              values[field_names[index].to_sym] = value
            end
          else
            values[field_names.to_sym] = response_body[:result][:record_data][:records][:field_values]
          end

          data << values
        end

      else
        data << response_body
      end

      data
    end

    def self.format_response_with_errors(error)
      error_response = { status: "failure" }

      if error.to_hash[:fault].has_key?(:detail) and !error.to_hash[:fault][:detail].nil?
        key = error.to_hash[:fault][:detail].keys[0]
        error_response[:error] = { http_status_code: error.http.code, code: error.to_hash[:fault][:detail][key][:exception_code], message: error.to_hash[:fault][:detail][key][:exception_message] }
        error_response[:error][:trace] = error.to_hash[:fault][:detail][:source] if error.to_hash[:fault][:detail].has_key?(:source)
      else
        error_response[:error] = { http_status_code: error.http.code, code: error.to_hash[:fault][:faultcode], message: error.to_hash[:fault][:faultstring] }
      end

      error_response
    end

    def self.format_response_with_message(i18n_key)
      { status: "failure", error: { http_status_code: "", code: "Internal client error", message: I18n.t(i18n_key) } }
    end
  end
end
