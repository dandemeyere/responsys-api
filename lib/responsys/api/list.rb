module Responsys
  module Api
    class List < Responsys::Api::Resource
      include Responsys::Api::Object

      attr_accessor :interact_object

      def resource_path
        "/rest/api/v1/lists"
      end

      def initialize(interact_object)
        #TODO param verification
        @interact_object = interact_object

        super()
      end

      def retrieve_record(query_column, field_list, id_to_retrieve)
        #TODO check param
        query = { qa: query_column.to_param, fs: field_list.join(","), id: id_to_retrieve }

        self.get("/#{@interact_object.object_name}", { query: query }, RecordData::ResponseFormatter)
      end

      def merge_records(record_data, list_merge_rule = ListMergeRule.new)
        body = {
          list: {
            folderName: @interact_object.folder_name
          },
          recordData: record_data.to_api,
          mergeRule: list_merge_rule.to_api
        }

        self.post("/#{@interact_object.object_name}", { body: body })
      end

      def extensions(extension_interact_object)
        Responsys::Api::Extension.new(self.interact_object, extension_interact_object)
      end
    end
  end
end

## These 2 objects haven't changed
## The interact object is a generic definition of a Responsys object:
##   - a folder name
##   - a file name
# client = Responsys::Api::Client.new
# interact_object = Responsys::Api::Object::InteractObject(folder_name, object_name)

### BEFORE (SOAP->Methods): all methods on the client, no distinction of the different resources / data model
# client.merge_list_members(interact_object, record_data, list_merge_rule)

### AFTER (REST->Resources): 2 different ways possible.

# The API definition to merge members of the list is the following
# POST/rest/api/v1/lists/<listName>

# 1) The chain of methods defines what you want to do.
# The syntax explicitly dictates which resources you're interacting with.
# client.lists(interact_object).merge_records(record_data, list_merge_rule)

#OR

# 2) You can use the direct Resource object. It's the same object as client.lists(interact_object) too.
# Responsys::Api::List(interact_object).merge_records(record_data, list_merge_rule)

###---------------------####
####### API METHODS ########
## Profile List Tables
# client.lists(interact_object).retrieve_record(query_column, field_list, id_to_retrieve)
# client.lists(interact_object).merge_records(record_data, list_merge_rule)

## Profile Extension Tables (or PET)
## A PET is always associated to a List.
# client.lists(interact_object).extensions(interact_object).create_table(fields)
# client.lists(interact_object).extensions(interact_object).merge_records(record_data, list_merge_rule)
# client.lists(interact_object).extensions(interact_object).retrieve_records(query_column, field_list, id_to_retrieve)
# client.lists(interact_object).extensions(interact_object).delete_record(query_column, id_to_delete)

## Supplemental Tables
## A Table can or cannot be associated to either previous types' data
# client.tables(interact_object).create_table(fields, primary_keys)
# client.tables(interact_object).merge_records(record_data, match_column_names)
# client.tables(interact_object).retrieve_recod(query_attribute, field_list, id_to_retrieve)
# client.tables(interact_object).delete_record(query_attribute, id_to_retrieve)

## Campaigns
# client.campaigns(name).trigger_email(...)
# client.campaigns(name).trigger_sms(...)

## Events
# client.events(name).trigger(...)