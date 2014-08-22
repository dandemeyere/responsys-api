module Responsys
  module Api
    module Object
      class Record
        attr_accessor :field_values

        def initialize(field_values)
          @field_values = field_values
        end

        def to_api
          { fieldValues: @field_values }
        end
      end
    end
  end
end