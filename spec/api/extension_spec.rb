require "spec_helper.rb"

describe Responsys::Api::Extension do
  before(:example) do
    @profile_list_interact_object = Responsys::Api::Object::InteractObject.new(DATA[:folder], DATA[:lists][:list1][:name])
    @profile_extension_interact_object = Responsys::Api::Object::InteractObject.new(DATA[:folder], DATA[:pets][:pet1][:name])
    @profile_extension_interact_object_create = Responsys::Api::Object::InteractObject.new(DATA[:folder], "pet_temp_#{Time.now.to_i}")
    @profile_extension_client = Responsys::Api::Extension.new(@profile_list_interact_object, @profile_extension_interact_object)
    @query_column_riid = Responsys::Api::Object::QueryColumn.new("RIID")
    @fields = %w(RIID_ MONTHLY_PURCH)
    @user_riid = DATA[:users][:user1][:RIID]
    @user_purch = DATA[:pets][:pet1][:records][:user1][:MONTHLY_PURCH]
    @table = Responsys::Api::Object::InteractObject.new(DATA[:folder], "table_temp")
    @table_with_pk = Responsys::Api::Object::InteractObject.new(DATA[:folder], "table_with_pk_temp")
  end

  context "create table" do
    it "should create an extension table" do
      VCR.use_cassette("api/extension/create_table") do
        extension_client = Responsys::Api::Extension.new(@profile_list_interact_object, @profile_extension_interact_object_create)

        fields = [
          Responsys::Api::Object::Field.new("field1", Responsys::Api::Object::FieldType.new("STR500"), custom = false, data_extraction_key = false),
          Responsys::Api::Object::Field.new("field2", Responsys::Api::Object::FieldType.new("NUMBER"), custom = false, data_extraction_key = false),
          Responsys::Api::Object::Field.new("field3", Responsys::Api::Object::FieldType.new("TIMESTAMP"), custom = false, data_extraction_key = false),
        ]

        response = extension_client.create_table(fields)

        expect(response.success?).to be_truthy
      end
    end
  end

  context "delete records" do
    it "should delete a profile extension member" do
      VCR.use_cassette("api/extension/delete_record") do
        response = @profile_extension_client.delete_record(@query_column_riid, @user_riid)

        expect(response.success?).to be_truthy
      end
    end
  end

  context "merge records" do
    it "should add (merge into) a profile extension member" do
      VCR.use_cassette("api/extension/merge_records") do
        record_data = Responsys::Api::Object::RecordData.new([{ RIID_: @user_riid, MONTHLY_PURCH: @user_purch }])
        response = @profile_extension_client.merge_records(record_data, "RIID", true)

        expect(response.success?).to be_truthy
      end
    end
  end

  context "retrieve_records" do
    it "should set the status to ok" do
      VCR.use_cassette("api/extension/retrieve_record") do
        response = @profile_extension_client.retrieve_record(@query_column_riid, @fields, @user_riid)

        expect(response.success?).to be_truthy
      end
    end

    it "should return one record" do
      VCR.use_cassette("api/extension/retrieve_record") do
        response = @profile_extension_client.retrieve_record(@query_column_riid, @fields, @user_riid)

        expect(response.data.length).to eq(1)
      end
    end

    it "should return two key-value pairs" do
      VCR.use_cassette("api/extension/retrieve_record") do
        response = @profile_extension_client.retrieve_record(@query_column_riid, @fields, @user_riid)

        expect(response.data[0]).to include({ RIID_: "48614925", MONTHLY_PURCH: "300" })
      end
    end
  end

end
