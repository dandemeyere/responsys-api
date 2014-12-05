require "i18n"

I18n.load_path.concat Dir.glob( File.dirname(__FILE__) + "/responsys/i18n/*.yml" )

require "responsys/configuration"

require "responsys/helpers/all"

require "responsys/exceptions/all"

require "responsys/api/object/all"
require "responsys/api/all"

require "responsys/api/client"
require "responsys/member"