module Responsys
  module Api
    module Table
      def create_table(interact_object, fields)
        api_method(:create_table, { table: interact_object.to_api, fields: fields.map(&:to_api) })
      end

      def create_table_with_pk(interact_object, fields, primary_keys)
        api_method(:create_table_with_pk, { table: interact_object.to_api, fields: fields.map(&:to_api), primaryKeys: primary_keys })
      end

      def delete_table(interact_object)
        api_method(:delete_table, { table: interact_object.to_api })
      end

      def merge_into_profile_extension(interact_object, record_data, match_column, insert_on_no_match = false, update_on_match = "REPLACE_ALL")
        api_method(:merge_into_profile_extension, { profileExtension: interact_object.to_api, recordData: record_data.to_api, matchColumn: match_column, insertOnNoMatch: insert_on_no_match, updateOnMatch: update_on_match })
      end

      def retrieve_profile_extension_records(interact_object, query_column, field_list, ids_to_retrieve)
        api_method(:retrieve_profile_extension_records, { profileExtension: interact_object.to_api, queryColumn: query_column.to_api, fieldList: field_list, idsToRetrieve: ids_to_retrieve })
      end

      def delete_profile_extension_members(interact_object, query_column, ids_to_delete)
        api_method(:delete_profile_extension_members, { profileExtension: interact_object.to_api, queryColumn: query_column.to_api, idsToDelete: ids_to_delete })
      end

      def merge_table_records

      end

      def merge_table_records_with_pk(interact_object, record_data, insert_on_no_match = true, update_on_match = "NO_UPDATE")
        api_method(:merge_table_records_with_pk, { table: interact_object.to_api, recordData: record_data.to_api, insertOnNoMatch: insert_on_no_match, updateOnMatch: update_on_match }) 
      end

      def delete_table_records

      end

      def retrieve_table_records

      end

      def truncate_table

      end
    end
  end
end