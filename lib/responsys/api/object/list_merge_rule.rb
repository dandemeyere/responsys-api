module Responsys
  module Api
    module Object
      class ListMergeRule
        attr_accessor :insertOnNoMatch, :updateOnMatch, :matchColumnName1, :matchColumnName2, :matchColumnName3, :matchOperator, :optinValue, :optoutValue, :htmlValue, :textValue, :rejectRecordIfChannelEmpty, :defaultPermissionStatus

        def initialize(options = {})
          self.insertOnNoMatch = options[:insertOnNoMatch].nil? ? false : options[:insertOnNoMatch]
          self.updateOnMatch = options[:updateOnMatch] || "REPLACE_ALL"
          self.matchColumnName1 = options[:matchColumnName1] || "EMAIL_ADDRESS_"
          self.matchColumnName2 = options[:matchColumnName2] || ""
          self.matchColumnName3 = options[:matchColumnName3] || ""
          self.matchOperator = options[:matchOperator] || "AND"
          self.optinValue = options[:optinValue] || "I"
          self.optoutValue = options[:optoutValue] || "O"
          self.htmlValue = options[:htmlValue] || "H"
          self.textValue = options[:textValue] || "T"
          self.rejectRecordIfChannelEmpty = options[:rejectRecordIfChannelEmpty] || ""
          self.defaultPermissionStatus = options[:defaultPermissionStatus] || ""
        end

        def to_hash
          {
            :insertOnNoMatch => insertOnNoMatch,
            :updateOnMatch => updateOnMatch,
            :matchColumnName1 => matchColumnName1,
            :matchColumnName2 => matchColumnName2,
            :matchColumnName3 => matchColumnName3,
            :matchOperator => matchOperator,
            :optinValue => optinValue,
            :optoutValue => optoutValue,
            :htmlValue => htmlValue,
            :textValue => textValue,
            :rejectRecordIfChannelEmpty => rejectRecordIfChannelEmpty,
            :defaultPermissionStatus => defaultPermissionStatus
          }
        end
      end
    end
  end
end