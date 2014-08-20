require "responsys/api/folder"
require "responsys/api/list"
require "responsys/api/session"
require "responsys/api/table"
require "responsys/api/campaign"

module Responsys
  module Api
    module All
      include Responsys::Api::Folder
      include Responsys::Api::List
      include Responsys::Api::Session
      include Responsys::Api::Table
      include Responsys::Api::Campaign
    end
  end
end