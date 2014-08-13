require "responsys/api/folder"
require "responsys/api/list"
require "responsys/api/session"

module Responsys
  module Api
    module All
      include Responsys::Api::Folder
      include Responsys::Api::List
      include Responsys::Api::Session
    end
  end
end