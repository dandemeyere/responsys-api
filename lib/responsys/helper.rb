module Responsys
  module Helper
    def self.format_response_result(response, action)
      response.body[("#{action}_response").to_sym][:result]
    end

    def self.format_response_hash(response, action)
      to_return = { status: "ok" }

      if response.body.has_key? "#{action}_response".to_sym
        if response.body["#{action}_response".to_sym][:result].is_a? Hash
          to_return[:data] = self.handle_response_types(response.body["#{action}_response".to_sym])
        else
          to_return[:result] = response.body["#{action}_response".to_sym][:result]
        end
      end

      to_return
    end

    def self.handle_response_types(response_body)
      data = []

      if response_body[:result].has_key? :record_data
        field_names = response_body[:result][:record_data][:field_names]

        if response_body[:result][:record_data][:records].is_a? Array

          response_body[:result][:record_data][:records].each do |record|
            values = {}

            record[:field_values].each_with_index do | value, index |
              values[field_names[index]] = value
            end

            data << values
          end

        else
          values = {}

          if response_body[:result][:record_data][:records][:field_values].is_a? Array
            response_body[:result][:record_data][:records][:field_values].each_with_index do | value, index |
              values[field_names[index]] = value
            end
          else
            values[field_names] = response_body[:result][:record_data][:records][:field_values]
          end

          data << values
        end

      else
        data << response_body
      end

      data
    end

    def self.format_response_with_errors(error)
      to_return = { status: "failure" }

      if error.to_hash[:fault].has_key?(:detail) and !error.to_hash[:fault][:detail].nil?
        key = error.to_hash[:fault][:detail].keys[0]
        to_return[:error] = { http_status_code: error.http.code, code: error.to_hash[:fault][:detail][key][:exception_code], message: error.to_hash[:fault][:detail][key][:exception_message] }
        to_return[:error][:trace] = error.to_hash[:fault][:detail][:source] if error.to_hash[:fault][:detail].has_key?(:source)
      else
        to_return[:error] = { http_status_code: error.http.code, code: error.to_hash[:fault][:faultcode], message: error.to_hash[:fault][:faultstring] }
      end

      to_return
    end

    def self.format_response_with_message(i18n_key)
      { status: "failure", error: { http_status_code: "", code: "Internal client error", message: I18n.t(i18n_key) } }
    end
  end
end
