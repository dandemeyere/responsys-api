module Responsys
  module Helpers
    def self.get_message(key)
      begin
        I18n.t(key, scope: :responsys_api, locale: I18n.locale, raise: true)
      rescue I18n::MissingTranslationData
        I18n.t(key, scope: :responsys_api, locale: :en, default: "Responsys - Unknown message '#{key}'")
      end
    end

    def self.array_of?(fields, type)
      fields.is_a?(Array) && fields.all? { |field| field.is_a?(type) }
    end
  end
end
