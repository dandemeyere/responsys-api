require 'responsys/api/folder'
require 'responsys/api/list'
require 'responsys/api/session'

module ResponsysApi
  module Api
    module All
      include ResponsysApi::Api::Folder
      include ResponsysApi::Api::List
      include ResponsysApi::Api::Session
    end
  end
end