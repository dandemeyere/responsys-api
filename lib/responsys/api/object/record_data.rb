module Responsys
  module Api
    module Object
      class RecordData
        attr_accessor :field_names, :field_values

        def initialize(field_names, field_values)
          self.field_names = field_names
          self.field_values = field_values
        end

        def to_api
          { fieldNames: field_names, records: { fieldValues: field_values } }
        end
      end
    end
  end
end