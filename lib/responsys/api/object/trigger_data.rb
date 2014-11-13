module Responsys
  module Api
    module Object
      class TriggerData
        attr_accessor :optional_data

        def initialize(optional_data = [Responsys::Api::Object::OptionalData.new])
          @optional_data = optional_data
        end

        def to_api
          { optionalData: @optional_data.map(&:to_api) }
        end
      end
    end
  end
end

