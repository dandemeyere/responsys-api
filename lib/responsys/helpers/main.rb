module Responsys
  module Helpers

    def self.format(params = {})
      result_hash = nil

      if params.has_key?(:response) && params.has_key?(:action)
        result_hash = Formatting::format_response_hash(params[:response], params[:action])
      elsif params.has_key?(:error)
        result_hash = Formatting::format_response_with_errors(params[:error])
      end

      Formatting::format_response_object_from_hash(result_hash)
    end

    def self.build_custom_error_response(message_key)
      hash = { success: false, error: { http_status_code: "", code: message_key.split('.')[-1], message: get_message(message_key) } }
      ResponseObject.new(hash)
    end

    def self.get_message(key)
      begin
        I18n.t(key, scope: :responsys_api, locale: I18n.locale, raise: true)
      rescue I18n::MissingTranslationData
        I18n.t(key, scope: :responsys_api, locale: :en, default: "Responsys - Unknown message '#{key}'")
      end
    end
  end
end