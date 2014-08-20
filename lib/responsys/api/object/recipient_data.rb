module Responsys
  module Api
    module Object
      class RecipientData
        attr_accessor :recipient, :optionalData

        def initialize(recipient, optionalData = default_optional_data)
          @recipient = recipient
          @optionalData = optionalData
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
