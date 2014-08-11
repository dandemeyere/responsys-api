module ResponsysApi
	module Api
		module List
         def retrieve_list_members(interactObject, queryColumn, fieldList, idsToRetrieve)
            message = {
               "list" => interactObject.to_hash,
               "queryColumn" => queryColumn,
               "fieldList" => fieldList,
               "idsToRetrieve" => idsToRetrieve
            }

            api_method(:retrieve_list_members, message)
         end

         def merge_list_members(interactObject, recordData, mergeRule=ResponsysApi::Api::Object::ListMergeRule.new)
            message = {
               "list" => interactObject.to_hash,
               "recordData" => recordData.to_hash,
               "mergeRule" => mergeRule.to_hash
            }

            api_method(:merge_list_members, message)
         end
      end
   end
end

# <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:urn="urn:ws.rsys.com">
#    <soapenv:Header>
#       <urn:SessionHeader>
#          <urn:sessionId>${sessionId}</urn:sessionId>
#       </urn:SessionHeader>
#    </soapenv:Header>
#    <soapenv:Body>
#       <urn:mergeListMembers>
#          <urn:list>
#             <urn:folderName>!MasterData</urn:folderName>
#             <urn:objectName>CONTACTS_LIST2</urn:objectName>
#          </urn:list>
#          <urn:recordData>
#             <!--1 or more repetitions:-->
#             <urn:fieldNames>EMAIL_ADDRESS_</urn:fieldNames>
#             <urn:fieldNames>MOBILE_NUMBER_</urn:fieldNames>
#             <urn:fieldNames>EMAIL_PERMISSION_STATUS_</urn:fieldNames>
#             <!--1 or more repetitions:-->
#             <urn:records>
#                <!--1 or more repetitions:-->
#                <urn:fieldValues>derek.fabela@oracle.com</urn:fieldValues>
#                <urn:fieldValues>6507872143</urn:fieldValues>
#                <urn:fieldValues>I</urn:fieldValues>
#             </urn:records>
#          </urn:recordData>
#          <urn:mergeRule>
#             <urn:insertOnNoMatch>true</urn:insertOnNoMatch>
#             <urn:updateOnMatch xsi:nil="true" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"/>
#             <urn:matchColumnName1>EMAIL_ADDRESS_</urn:matchColumnName1>
#             <urn:matchColumnName2 xsi:nil="true" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"/>
#             <urn:matchColumnName3 xsi:nil="true" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"/>
#             <urn:matchOperator xsi:nil="true" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"/>
#             <urn:optinValue>I</urn:optinValue>
#             <urn:optoutValue xsi:nil="true" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"/>
#             <urn:htmlValue xsi:nil="true" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"/>
#             <urn:textValue xsi:nil="true" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"/>
#             <urn:rejectRecordIfChannelEmpty xsi:nil="true" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"/>
#             <urn:defaultPermissionStatus xsi:nil="true" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"/>
#          </urn:mergeRule>
#       </urn:mergeListMembers>
#    </soapenv:Body>
# </soapenv:Envelope>