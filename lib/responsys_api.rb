require "i18n"

I18n.load_path = ["lib/responsys/i18n/en.yml"]
I18n.locale = :en
I18n.enforce_available_locales = false

require "responsys/exceptions/all"
require "responsys/helper"
require "responsys/configuration"
require "responsys/api/client"
require "responsys/member"