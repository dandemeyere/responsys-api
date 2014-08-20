module Responsys
  module Api
    module Object
      class RecipientData
        attr_accessor :recipient, :optionalData

        def initialize(recipient, optionalData = nil)
          @recipient = recipient
          @optionalData = optionalData.nil? ? default_optional_data : optionalData
        end

        def to_hash
          {
            recipient: @recipient.to_hash,
            optionalData: @optionalData
          }
        end

        def default_optional_data
          [{
            name: "",
            value: ""
          }]
        end
      end
    end
  end
end
