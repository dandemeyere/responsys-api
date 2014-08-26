module Responsys
  module Api
    module Object
      class OptionalData
        include Responsys::Exceptions
        attr_accessor :name, :value

        def initialize(name = "", value = "")
          raise ParameterException, I18n.t("api.object.optional_data.incorrect_optional_data_type") unless (name.is_a? String) && (value.is_a? String)
          @name = name
          @value = value
        end

        def to_api
          {
            Name: @name,
            Value: @value
          }
        end
      end
    end
  end
end