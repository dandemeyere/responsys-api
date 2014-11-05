require "i18n"

I18n.load_path.concat Dir.glob( File.dirname(__FILE__) + "/responsys/i18n/*.yml" )

require "responsys/exceptions/all"
require "responsys/helper"
require "responsys/configuration"
require "responsys/api/client"
require "responsys/member"
