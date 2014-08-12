require 'responsys/api/all'
require 'responsys/api/object/all'

module Responsys
  class Member
    include Responsys::Api
    include Responsys::Api::Object
    attr_accessor :email

    # Creates a Member object.
    # Params:
    # +email+:: email of the member
    def initialize(email)
      @email = email
      @client = Client.instance
    end

    # Update the information of the Member.
    # Params:
    # +list+:: +Responsys::Api::Object::Interactobject+ which representents the list to update.
    # +data+:: +Hash+ composed of all the data to update as {field1:value1, field2:value2}
    def update(list, data)
      record = RecordData.new(data.keys, data.values)
      @client.merge_list_members(list, record)
    end

    # Subscribe the Member to the list. This is an update of the field 'EMAIL_PERMISSION_STATUS_' to OptIn char 'I'.
    # Params:
    # +list+:: +Responsys::Api::Object::Interactobject+ which representents the list.
    def subscribe(list)
      update(list, {"EMAIL_ADDRESS_" => @email, "EMAIL_PERMISSION_STATUS_" => "I"})
    end

    # Give the subscribe status of the Member for the list
    # Params:
    # +list+:: +Responsys::Api::Object::Interactobject+ which representents the list.
    def subscribed?(list)
      response = @client.retrieve_list_members(list, "EMAIL_ADDRESS", ["EMAIL_PERMISSION_STATUS_"], [@email])
      response[:record_data][:records][:field_values] == "I"
    end

    # Unsubscribe the Member to the list. This is an update of the field 'EMAIL_PERMISSION_STATUS_' to OptOut char 'O'.
    # Params:
    # +list+:: +Responsys::Api::Object::Interactobject+ which representents the list.
    def unsubscribe(list)
      update(list, {"EMAIL_ADDRESS_" => @email, "EMAIL_PERMISSION_STATUS_" => "O"})
    end
  end
end