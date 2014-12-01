require "i18n"

I18n.load_path.concat Dir.glob( File.dirname(__FILE__) + "/responsys/i18n/*.yml" )

require "responsys/helpers/formatting"
require "responsys/helpers/response_object"
require "responsys/helpers/main"

require "responsys/exceptions/all"

require "responsys/configuration"
require "responsys/api/client"
require "responsys/member"