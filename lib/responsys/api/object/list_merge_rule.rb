module Responsys
  module Api
    module Object
      class ListMergeRule
        attr_accessor :insert_on_no_match, :update_on_match, :match_column_name1, :match_column_name2, :match_column_name3, :match_operator, :optin_value, :optout_value, :html_value, :text_value, :reject_record_if_channel_empty, :default_permission_status

        def initialize(options = {})
          @insert_on_no_match = options[:insertOnNoMatch].nil? ? false : options[:insertOnNoMatch]
          @update_on_match = options[:updateOnMatch] || "REPLACE_ALL"
          @match_column_name1 = options[:matchColumnName1] || "EMAIL_ADDRESS_"
          @match_column_name2 = options[:matchColumnName2] || ""
          @match_column_name3 = options[:matchColumnName3] || ""
          @match_operator = options[:matchOperator] || "AND"
          @optin_value = options[:optinValue] || "I"
          @optout_value = options[:optoutValue] || "O"
          @html_value = options[:htmlValue] || "H"
          @text_value = options[:textValue] || "T"
          @reject_record_if_channel_empty = options[:rejectRecordIfChannelEmpty] || ""
          @default_permission_status = options[:defaultPermissionStatus] || "OPTOUT"
        end

        def to_api
          {
            insertOnNoMatch: @insert_on_no_match,
            updateOnMatch: @update_on_match,
            matchColumnName1: @match_column_name1,
            matchColumnName2: @match_column_name2,
            matchColumnName3: @match_column_name3,
            matchOperator: @match_operator,
            optinValue: @optin_value,
            optoutValue: @optout_value,
            htmlValue: @html_value,
            textValue: @text_value,
            rejectRecordIfChannelEmpty: @reject_record_if_channel_empty,
            defaultPermissionStatus: @default_permission_status
          }
        end
      end
    end
  end
end