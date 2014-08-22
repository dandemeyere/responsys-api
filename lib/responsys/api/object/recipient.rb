module Responsys
  module Api
    module Object
      class Recipient
        include Responsys::Api::Object
        attr_accessor :list_name, :recipient_id, :customer_id, :email_address, :mobile_number, :email_format

        def initialize(options = {})
          @list_name = options[:listName] || InteractObject.new("", "")
          @recipient_id = options[:recipientId] || ""
          @customer_id = options[:customerId] || ""
          @email_address = options[:emailAddress] || ""
          @mobile_number = options[:mobileNumber] || ""
          @email_format = options[:emailFormat] || EmailFormat.new
        end

        def to_api
          { 
            listName: @list_name.to_api,
            recipientId: @recipient_id.to_i,
            customerId: @customer_id.to_s,
            emailAddress: @email_address.to_s,
            mobileNumber: @mobile_number.to_s,
            emailFormat: @email_format.to_api
          }
        end
      end
    end
  end
end