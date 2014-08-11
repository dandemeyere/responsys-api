module ResponsysApi
	class Member
		attr_accessor :email, :client

		def initialize(email, client)
			self.email = email
			self.client = client
		end

		def update(list, data)
			record = ResponsysApi::Api::Object::RecordData.new(data.keys, data.values)
			client.merge_list_members(list, record)
		end

		def subscribe(list)
			update(list, {"EMAIL_ADDRESS_" => self.email, "EMAIL_PERMISSION_STATUS_" => "I"})
		end

		def subscribed?(list)
			response = client.retrieve_list_members(list, "EMAIL_ADDRESS", ["EMAIL_PERMISSION_STATUS_"], [self.email])
			response[:record_data][:records][:field_values] == "I"
		end

		def unsubscribe(list)
			update(list, {"EMAIL_ADDRESS_" => self.email, "EMAIL_PERMISSION_STATUS_" => "O"})
		end
	end
end