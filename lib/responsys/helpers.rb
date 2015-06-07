module Responsys
  module Helpers
    def self.get_message(key)
      begin
        I18n.t(key, scope: :responsys_api, locale: I18n.locale, raise: true)
      rescue I18n::MissingTranslationData
        I18n.t(key, scope: :responsys_api, locale: :en, default: "Responsys - Unknown message '#{key}'")
      end
    end
  end
end