module ResponsysApi
  class Member
    attr_accessor :email, :client

    # Creates a Member object.
    # Params:
    # +email+:: email of the member
    # +client+:: +ResponsysApi::Client::Api+ object that has been instanciated and logged in.
    def initialize(email, client)
      self.email = email
      self.client = client
    end

    # Update the information of the Member.
    # Params:
    # +list+:: +ResponsysApi::Api::Object::Interactobject+ which representents the list to update.
    # +data+:: +Hash+ composed of all the data to update as {field1:value1, field2:value2}
    def update(list, data)
      record = ResponsysApi::Api::Object::RecordData.new(data.keys, data.values)
      client.merge_list_members(list, record)
    end

    # Subscribe the Member to the list. This is an update of the field 'EMAIL_PERMISSION_STATUS_' to OptIn char 'I'.
    # Params:
    # +list+:: +ResponsysApi::Api::Object::Interactobject+ which representents the list.
    def subscribe(list)
      update(list, {"EMAIL_ADDRESS_" => self.email, "EMAIL_PERMISSION_STATUS_" => "I"})
    end

    # Give the subscribe status of the Member for the list
    # Params:
    # +list+:: +ResponsysApi::Api::Object::Interactobject+ which representents the list.
    def subscribed?(list)
      response = client.retrieve_list_members(list, "EMAIL_ADDRESS", ["EMAIL_PERMISSION_STATUS_"], [self.email])
      response[:record_data][:records][:field_values] == "I"
    end

    # Unsubscribe the Member to the list. This is an update of the field 'EMAIL_PERMISSION_STATUS_' to OptOut char 'O'.
    # Params:
    # +list+:: +ResponsysApi::Api::Object::Interactobject+ which representents the list.
    def unsubscribe(list)
      update(list, {"EMAIL_ADDRESS_" => self.email, "EMAIL_PERMISSION_STATUS_" => "O"})
    end
  end
end