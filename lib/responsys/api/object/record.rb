module Responsys
  module Api
    module Object
      class Record
        include Responsys::Exceptions
        attr_accessor :field_values

        def initialize(field_values)
          raise ParameterException.new("api.object.record.incorrect_field_values_type") unless field_values.is_a?(Array)
          @field_values = field_values
        end

        def to_api
          { fieldValues: @field_values }
        end
      end
    end
  end
end