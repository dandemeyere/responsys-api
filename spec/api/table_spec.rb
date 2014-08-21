require "spec_helper.rb"

describe Responsys::Api::Table do

  before(:example) do
    @profile_extension = Responsys::Api::Object::InteractObject.new("another_test_folder", "test_profile_extension")
    @query_column_riid = Responsys::Api::Object::QueryColumn.new("RIID")
    @query_column_email = Responsys::Api::Object::QueryColumn.new("EMAIL_ADDRESS")
    @fields = %w(RIID_ EMAIL_ADDRESS)
    @user_riid = 398426
    @user_email = "user2@email.com"

    VCR.use_cassette("api/profile_extension/login") do
      Responsys::Api::Client.instance.login
    end
  end

  context "create table" do
    before(:all) do
      @table = Responsys::Api::Object::InteractObject.new("another_test_folder", "table_#{Time.now.to_i}")
      @table_with_pk = Responsys::Api::Object::InteractObject.new("another_test_folder", "table_with_pk_#{Time.now.to_i}")
    end

    it "should create a table" do
      VCR.use_cassette("api/table/create") do
        fields = [
          Responsys::Api::Object::Field.new("field1", Responsys::Api::Object::FieldType.new("STR500"), custom = false, data_extraction_key = false),
          Responsys::Api::Object::Field.new("field2", Responsys::Api::Object::FieldType.new("NUMBER"), custom = false, data_extraction_key = false),
          Responsys::Api::Object::Field.new("field3", Responsys::Api::Object::FieldType.new("TIMESTAMP"), custom = false, data_extraction_key = false),
        ]
        response = Responsys::Api::Client.instance.create_table(@table, fields)

        expect(response[:result]).to be(true)
      end
    end

    it "should delete the previous table" do
      VCR.use_cassette("api/table/delete") do
        response = Responsys::Api::Client.instance.delete_table(@table)

        expect(response[:result]).to be(true)
      end
    end

    it "should create a table with pk" do
      VCR.use_cassette("api/table/create_with_pk") do
        fields = [
          Responsys::Api::Object::Field.new("field1", Responsys::Api::Object::FieldType.new("STR500"), custom = false, data_extraction_key = false),
          Responsys::Api::Object::Field.new("field2", Responsys::Api::Object::FieldType.new("NUMBER"), custom = false, data_extraction_key = false),
          Responsys::Api::Object::Field.new("field3", Responsys::Api::Object::FieldType.new("TIMESTAMP"), custom = false, data_extraction_key = false),
        ]
        response = Responsys::Api::Client.instance.create_table_with_pk(@table_with_pk, fields, %w(field1))

        expect(response[:result]).to be(true)
      end
    end

    it "should delete the previous table with pk" do
      VCR.use_cassette("api/table/delete_with_pk") do
        response = Responsys::Api::Client.instance.delete_table(@table_with_pk)

        expect(response[:result]).to be(true)
      end
    end
  end

  context "retrieve_profile_extension_records" do

    it "should set the status to ok" do
      VCR.use_cassette("api/profile_extension/retrieve_profile_extension_records") do
        response = Responsys::Api::Client.instance.retrieve_profile_extension_records(@profile_extension, @query_column_riid, @fields, %W(#{@user_riid}))

        expect(response[:status]).to eq("ok")
      end
    end

    it "should return one record" do
      VCR.use_cassette("api/profile_extension/retrieve_profile_extension_records") do
        response = Responsys::Api::Client.instance.retrieve_profile_extension_records(@profile_extension, @query_column_riid, @fields, %W(#{@user_riid}))

        expect(response[:data].length).to eq(1)
      end
    end

    it "should return two key-value pairs" do
      VCR.use_cassette("api/profile_extension/retrieve_profile_extension_records") do
        response = Responsys::Api::Client.instance.retrieve_profile_extension_records(@profile_extension, @query_column_riid, @fields, %W(#{@user_riid}))

        expect(response[:data][0].length).to eq(2)
      end
    end

    it "should add (merge into) a profile extension member" do
      VCR.use_cassette("api/profile_extension/merge_profile_extension_records") do
        record_data = Responsys::Api::Object::RecordData.new(%w(EMAIL_ADDRESS_ MONTHLY_PURCH), %W(#{@user_email} 3000))
        response = Responsys::Api::Client.instance.merge_into_profile_extension(@profile_extension, record_data, "EMAIL_ADDRESS", true)

        expect(response[:status]).to eq("ok")
      end
    end

    it "should delete a profile extension member" do
      VCR.use_cassette("api/profile_extension/retrieve_profile_extension_records") do
        response = Responsys::Api::Client.instance.delete_profile_extension_members(@profile_extension, @query_column_email, %W{#{@user_email}})

        expect(response[:status]).to eq("ok")
      end
    end

  end
end