module Responsys
  module Api
    module Object
      class RecipientData
        attr_accessor :recipient, :optional_data

        def initialize(recipient, optional_data = nil)
          @recipient = recipient
          @optional_data = optional_data
        end

        def to_api
          {
            recipient: @recipient.to_api,
            optionalData: @optional_data ? @optional_data.map(&:to_api) : @optional_data
          }
        end
      end
    end
  end
end
