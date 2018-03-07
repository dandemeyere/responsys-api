require "responsys/api/authentication"
require "responsys/api/folder"
require "responsys/api/list"
require "responsys/api/table"
require "responsys/api/campaign"
require "responsys/api/job"

module Responsys
  module Api
    module All
      include Responsys::Api::Authentication
      include Responsys::Api::Folder
      include Responsys::Api::List
      include Responsys::Api::Table
      include Responsys::Api::Campaign
      include Responsys::Api::Job
    end
  end
end
