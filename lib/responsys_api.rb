require "i18n"
require "httparty"
require "deep_merge"

I18n.load_path.concat Dir.glob( File.dirname(__FILE__) + "/responsys/i18n/*.yml" )

require "responsys/monkey_patches"
require "responsys/helpers"
require "responsys/exceptions"
require "responsys/configuration"
require "responsys/api/object/all"
require "responsys/api/authentication"
require "responsys/api/resource"
require "responsys/api/all"
require "responsys/api/response"
require "responsys/api/client"
require "responsys/member"