module Responsys
  module Api
    class Table < Responsys::Api::Resource
      attr_accessor :interact_object

      def resource_path
        "/rest/api/v1/folders/#{@interact_object.folder_name}/suppData"
      end

      def initialize(interact_object)
        @interact_object = interact_object

        super()
      end

      def create_table(fields, primary_keys)
        #fields is an array of Field
        body = {
          table: { objectName: @interact_object.object_name },
          fields: fields.map(&:to_api),
          primaryKeys: primary_keys
        }

        self.post("/", { body: body })
      end

      def merge_records(record_data, match_column_names)
        body = {
          recordData: record_data.to_api,
          matchColumnNames: match_column_names
        }

        self.post("/#{@interact_object.object_name}", { body: body })
      end

      def merge_records_with_pk(record_data, insert_on_no_match = true, update_on_match = "REPLACE_ALL")
        body = {
          recordData: record_data.to_api,
          insertOnNoMatch: insert_on_no_match,
          updateOnMatch: update_on_match
        }

        self.post("/#{@interact_object.object_name}", { body: body })
      end

      def retrieve_record(query_attribute, field_list, id_to_retrieve)
        params = {
          qa: query_attribute,
          fs: field_list.join(","),
          id: id_to_retrieve
        }

        self.get("/#{@interact_object.object_name}", { query: params })
      end

      def delete_record(query_attribute, id_to_retrieve)
        params = {
          qa: query_attribute,
          id: id_to_retrieve
        }

        self.delete("/#{@interact_object.object_name}", { query: params })
      end

      # client = Responsys::Api::Client.new

      # client.lists(interact_object).get
      # client.lists(interact_object).merge

      # client.tables(interact_object).create_table(fields, primary_keys)
      # client.tables(interact_object).merge_records(record_data, match_column_names)
      # client.tables(interact_object).retrieve_recod(query_attribute, field_list, id_to_retrieve)
      # client.tables(interact_object).delete_record(query_attribute, id_to_retrieve)

      # Responsys::Api::List(interact_object).retrieve_record
      # Responsys::Api::List(interact_object).merge_records

      # client.tables.create
      # client.tables.merge
      # client.tables.merge_pk
      # client.tables.get
      # client.tables.delete

      # client.campaigns(name).trigger_email
      # client.campaigns(name).trigger_sms

      # client.events(name).trigger
    end
  end
end