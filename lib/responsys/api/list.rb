require "responsys/api/object/all"

module Responsys
  module Api
    module List
      include Responsys::Api::Object
      def retrieve_list_members(interact_object, query_column, field_list, ids_to_retrieve)
        message = {
          list: interact_object.to_api,
          queryColumn: query_column.to_api,
          fieldList: field_list,
          idsToRetrieve: ids_to_retrieve
        }

        api_method(:retrieve_list_members, message)
      end

      def merge_list_members(interact_object, record_data, merge_rule = ListMergeRule.new)
        message = {
          list: interact_object.to_api,
          recordData: record_data.to_api,
          mergeRule: merge_rule.to_api
        }

        api_method(:merge_list_members, message)
      end

      def merge_list_members_riid(interact_object, record_data, merge_rule = ListMergeRule.new)
        message = {
          list: interact_object.to_api,
          recordData: record_data.to_api,
          mergeRule: merge_rule.to_api
        }

        api_method(:merge_list_members_riid, message)
      end
    end
  end
end