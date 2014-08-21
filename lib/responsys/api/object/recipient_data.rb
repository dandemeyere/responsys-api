module Responsys
  module Api
    module Object
      class RecipientData
        attr_accessor :recipient, :optional_data

        def initialize(recipient, optional_data = default_optional_data)
          @recipient = recipient
          @optional_data = optional_data
        end

        def to_api
          {
            recipient: @recipient.to_api,
            optionalData: @optional_data
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
