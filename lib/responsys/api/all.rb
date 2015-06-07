require "responsys/api/list"
require "responsys/api/extension"
require "responsys/api/table"
require "responsys/api/campaign"
require "responsys/api/event"

module Responsys
  module Api
    module All
      def lists(interact_object)
        Responsys::Api::List.new(interact_object)
      end

      def tables(interact_object)
        Responsys::Api::Table.new(interact_object)
      end

      def campaigns(campaign_name)
        Responsys::Api::Campaign.new(campaign_name)
      end

      def events(custom_event)
        Responsys::Api::Event.new(custom_event)
      end
    end
  end
end