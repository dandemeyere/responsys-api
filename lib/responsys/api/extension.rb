module Responsys
  module Api
    class Extension < Responsys::Api::List
      attr_accessor :profile_list_interact_object, :profile_extension_interact_object

      def resource_path
        "/rest/api/v1/lists/#{@profile_list_interact_object.object_name}/listExtensions"
      end

      def initialize(profile_list_interact_object, profile_extension_interact_object)
        #raise if one is nil
        @profile_list_interact_object = profile_list_interact_object
        @profile_extension_interact_object = profile_extension_interact_object

        super(@profile_list_interact_object)
      end

      def create_table(fields)
        #TODO fields must be an array of field
        body = {
          profileExtension: profile_extension_interact_object.to_api,
          fields: fields
        }

        self.post("/", { body: body })
      end

      def merge_records(record_data, match_column, insert_on_no_match = false, update_on_match = "REPLACE_ALL")
        body = {
          recordData: record_data.to_api,
          insertOnNoMatch: insert_on_no_match,
          updateOnMatch: update_on_match,
          matchColumn: match_column
        }

        self.post("/#{@profile_extension_interact_object.object_name}", { body: body })
      end

      def retrieve_record(query_column, field_list, id_to_retrieve)
        #TODO check param
        query = { qa: query_column.to_param, fs: field_list.join(","), id: id_to_retrieve }

        self.get("/#{@profile_extension_interact_object.object_name}", { query: query }, RecordData::ResponseFormatter)
      end

      def delete_record(query_column, id_to_delete)
        query = { qa: query_column.to_param, id: id_to_delete }

        self.delete("/#{@profile_extension_interact_object.object_name}", { query: query })
      end
    end
  end
end

# client.lists(interact_object).extensions(interact_object).create_table(fields)
# client.lists(interact_object).extensions(interact_object).merge_records(record_data, list_merge_rule)
# client.lists(interact_object).extensions(interact_object).retrieve_records(query_column, field_list, id_to_retrieve)
# client.lists(interact_object).extensions(interact_object).delete_record(query_column, id_to_delete)