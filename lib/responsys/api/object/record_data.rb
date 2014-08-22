module Responsys
  module Api
    module Object
      class RecordData
        include Responsys::Exceptions
        attr_accessor :field_names, :field_values

        def initialize(data)
          raise ParameterException, I18n.t("api.object.record_data.incorrect_type") unless data.is_a? Array

          self.field_names = data.map { |record| record.keys }.flatten.uniq
          field_names.each { |field_name| data.map { |entity| entity[field_names] = "" unless entity.has_key?(field_name) } }
          self.field_values = data.map { |record| record.values }
        end

        def to_api
          { fieldNames: field_names, records: { fieldValues: field_values } }
        end
      end
    end
  end
end
