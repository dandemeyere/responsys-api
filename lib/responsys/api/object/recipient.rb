module Responsys
  module Api
    module Object
      class Recipient
        include Responsys::Api::Object
        attr_accessor :list_name, :recipient_id, :customer_id, :email_address, :mobile_number, :email_format

        def initialize(options = {})
          @list_name = options[:listName] || nil
          @recipient_id = options[:recipientId] || nil
          @customer_id = options[:customerId] || nil
          @email_address = options[:emailAddress] || nil
          @mobile_number = options[:mobileNumber] || nil
          @email_format = options[:emailFormat] || nil
        end

        def to_api
          { 
            listName: @list_name.try(:to_api),
            recipientId: @recipient_id.try(:to_i),
            customerId: @customer_id.try(:to_s),
            emailAddress: @email_address.try(:to_s),
            mobileNumber: @mobile_number.try(:to_s),
            emailFormat: @email_format.try(:to_api)
          }
        end
      end
    end
  end
end