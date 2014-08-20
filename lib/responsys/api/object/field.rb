module Responsys
  module Api
    module Object
      class Field
        attr_accessor :field_name, :field_type, :custom, :data_extraction_key

        def initialize(field_name, field_type, custom = false, data_extraction_key = false)
          self.field_name =  field_name
          self.field_type = field_type
          self.custom = custom
          self.data_extraction_key = data_extraction_key
        end

        def to_api
          { fieldName: field_name, fieldType: field_type.to_api, custom: custom, dataExtractionKey: data_extraction_key }
        end
      end
    end
  end
end