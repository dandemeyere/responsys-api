module ResponsysApi
	module Api
		module Object
			class ListMergeRule
				attr_accessor :insertOnNoMatch, :updateOnMatch, :matchColumnName1, :matchColumnName2, :matchColumnName3, :matchOperator, :optinValue, :optoutValue, :htmlValue, :textValue, :rejectRecordIfChannelEmpty, :defaultPermissionStatus

				def initialize(
					insertOnNoMatch=true, 
					updateOnMatch="REPLACE_ALL", 
					matchColumnName1="EMAIL_ADDRESS_", 
					matchColumnName2="", 
					matchColumnName3="", 
					matchOperator="AND", 
					optinValue="I", 
					optoutValue="O", 
					htmlValue="H", 
					textValue="T", 
					rejectRecordIfChannelEmpty="", 
					defaultPermissionStatus="")

				self.insertOnNoMatch = insertOnNoMatch
				self.updateOnMatch = updateOnMatch
				self.matchColumnName1 = matchColumnName1
				self.matchColumnName2 = matchColumnName2
				self.matchColumnName3 = matchColumnName3
				self.matchOperator = matchOperator
				self.optinValue = optinValue
				self.optoutValue = optoutValue
				self.htmlValue = htmlValue
				self.textValue = textValue
				self.rejectRecordIfChannelEmpty = rejectRecordIfChannelEmpty
				self.defaultPermissionStatus = defaultPermissionStatus
			end

			def to_hash
				{
					"insertOnNoMatch" => insertOnNoMatch,
					"updateOnMatch" => updateOnMatch,
					"matchColumnName1" => matchColumnName1,
					"matchColumnName2" => matchColumnName2,
					"matchColumnName3" => matchColumnName3,
					"matchOperator" => matchOperator,
					"optinValue" => optinValue,
					"optoutValue" => optoutValue,
					"htmlValue" => htmlValue,
					"textValue" => textValue,
					"rejectRecordIfChannelEmpty" => rejectRecordIfChannelEmpty,
					"defaultPermissionStatus" => defaultPermissionStatus
				}
			end
		end
	end
end
end