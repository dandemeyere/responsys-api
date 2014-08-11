module Responsys
  module Api
    module Object
      class RecordData
        attr_accessor :fieldNames, :fieldValues

        def initialize(fieldNames, fieldValues)
          self.fieldNames = fieldNames
          self.fieldValues = fieldValues
        end

        def to_hash
          {"fieldNames" => fieldNames, "records" => {"fieldValues" => fieldValues } }
        end
      end
    end
  end
end