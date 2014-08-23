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

    def self.format_record_data(record_data)
      field_names = record_data[:field_names]
      records = record_data[:records]

      data = []
      if records.is_a? Array
        records.each do |record|
          data << format_field_values(record, field_names)
        end
      else
        data << format_field_values(records, field_names)
      end

      data
    end

    def self.format_field_values(record, field_names)
      values = {}

      if record.is_a? Array
        record[:field_values].each_with_index do |value, index|
          values[field_names[index].to_sym] = value
        end
      else
        values[field_names.to_sym] = record[:field_values]
      end

      values
    end

    def self.handle_response_types(response_body)
      data = []

      if response_body[:result].has_key? :record_data
        data = format_record_data(response_body[:result][:record_data])
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
