module Responsys
  module Api
    module Object
      class Record
        attr_accessor :fieldValues

        def initialize(fieldValues)
          self.fieldValues = fieldValues
        end

        def to_hash
          { :fieldValues => fieldValues }
        end
      end
    end
  end
end