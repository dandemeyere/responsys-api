module Responsys
  module Api
    module Object
      class OptionalData
        include Responsys::Exceptions
        attr_accessor :options

        def initialize(options={})
          raise ParameterException, I18n.t("api.object.optional_data.incorrect_optional_data_type") unless (options.is_a? Hash)
          @options = options
        end

        def to_api
          options_array = []
          options.each do |key, value|
            options_array << { Name: key, Value: value}
          end
          options_array
        end
      end
    end
  end
end
