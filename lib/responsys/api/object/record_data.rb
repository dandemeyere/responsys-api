module Responsys
  module Api
    module Object
      class RecordData
        include Responsys::Exceptions
        include Responsys::Api::Object
        attr_accessor :field_names, :records

        def initialize(data)
          raise ParameterException, I18n.t("api.object.record_data.incorrect_record_data_type") unless data.is_a? Array

          self.field_names = data.map { |record| record.keys }.flatten.uniq

          new_data = []
          field_names.each { |field_name|
            data.each_with_index { |entity, index|
              new_data[index] ||= Record.new([])
              new_data[index].field_values << (entity.has_key?(field_name) ? entity[field_name.to_sym] : "")
            }
          }

          self.records = new_data
        end

        def to_api
          { fieldNames: field_names, records: records.map(&:to_api) }
        end
      end
    end
  end
end
