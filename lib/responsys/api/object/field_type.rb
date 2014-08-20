module Responsys
  module Api
    module Object
      class FieldType
        include Responsys::Exceptions
        attr_accessor :field_type_string
        FIELD_TYPES = %w(STR500 STR4000 NUMBER TIMESTAMP INTEGER)

        def initialize(field_type)
          if FIELD_TYPES.include? field_type
            self.field_type_string = field_type
          else
            raise ParameterException, I18n.t("api.object.field_type.incorrect")
          end
        end

        def to_api
          field_type_string
        end
      end
    end
  end
end