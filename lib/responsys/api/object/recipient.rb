module Responsys
  module Api
    module Object
      class Recipient
        include Responsys::Api::Object
        attr_accessor :listName, :recipientId, :customerId, :emailAddress, :mobileNumber, :emailFormat

        def initialize(options = {})
          @listName = options[:listName] || InteractObject.new("", "")
          @recipientId = options[:recipientId] || ""
          @customerId = options[:customerId] || ""
          @emailAddress = options[:emailAddress] || ""
          @mobileNumber = options[:mobileNumber] || ""
          @emailFormat = options[:emailFormat] || ""
        end

        def to_hash
          { 
            listName: @listName.to_hash,
            recipientId: @recipientId.to_i,
            customerId: @customerId.to_s,
            emailAddress: @emailAddress.to_s,
            mobileNumber: @mobileNumber.to_s,
            emailFormat: @emailFormat 
          }
        end
      end
    end
  end
end