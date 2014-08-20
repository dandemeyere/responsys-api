module Responsys
  module Api
    module Object
      class Fields
        attr_accessor :fields

        def initialize(fields)
          self.fields = fields
        end

        def to_api
          fields.collect { |field| field.to_hash }
        end
      end
    end
  end
end