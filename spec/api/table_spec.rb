require "spec_helper.rb"

describe Responsys::Api::Table do

  before(:example) do
    @profile_extension = Responsys::Api::Object::InteractObject.new(DATA[:folder], DATA[:pets][:pet1][:name])
    @query_column_riid = Responsys::Api::Object::QueryColumn.new("RIID")
    @fields = %w(RIID_ MONTHLY_PURCH)
    @user_riid = DATA[:users][:user1][:RIID]
    @user_purch = DATA[:pets][:pet1][:records][:user1][:MONTHLY_PURCH]
  end

  context "create table" do
    before(:all) do
      @table = Responsys::Api::Object::InteractObject.new(DATA[:folder], "table_temp")
      @table_with_pk = Responsys::Api::Object::InteractObject.new(DATA[:folder], "table_with_pk_temp")
    end

    # it "should create a table" do
    #   VCR.use_cassette("api/table/create") do
    #     fields = [
    #       Responsys::Api::Object::Field.new("field1", Responsys::Api::Object::FieldType.new("STR500"), custom = false, data_extraction_key = false),
    #       Responsys::Api::Object::Field.new("field2", Responsys::Api::Object::FieldType.new("NUMBER"), custom = false, data_extraction_key = false),
    #       Responsys::Api::Object::Field.new("field3", Responsys::Api::Object::FieldType.new("TIMESTAMP"), custom = false, data_extraction_key = false),
    #     ]
    #     response = Responsys::Api::Client.new.create_table(@table, fields)

    #     expect(response[:result]).to be(true)
    #   end
    # end

    # it "should delete the previous table" do
    #   VCR.use_cassette("api/table/delete") do
    #     response = Responsys::Api::Client.new.delete_table(@table)

    #     expect(response[:result]).to be(true)
    #   end
    # end

    it "should create a table with pk" do
      VCR.use_cassette("api/table/create_with_pk") do
        fields = [
          Responsys::Api::Object::Field.new("field1", Responsys::Api::Object::FieldType.new("STR500"), custom = false, data_extraction_key = false),
          Responsys::Api::Object::Field.new("field2", Responsys::Api::Object::FieldType.new("NUMBER"), custom = false, data_extraction_key = false),
          Responsys::Api::Object::Field.new("field3", Responsys::Api::Object::FieldType.new("TIMESTAMP"), custom = false, data_extraction_key = false),
        ]
        response = Responsys::Api::Client.new.create_table_with_pk(@table_with_pk, fields, %w(field1))

        expect(response[:result]).to be(true)
      end
    end

    it "should delete the previous table with pk" do
      VCR.use_cassette("api/table/delete_with_pk") do
        response = Responsys::Api::Client.new.delete_table(@table_with_pk)

        expect(response[:result]).to be(true)
      end
    end
  
    it "should merge table records with pk" do
      VCR.use_cassette("api/table/merge_table_records_with_pk") do
       record_data = Responsys::Api::Object::RecordData.new([{EMAIL_ADDRESS_: @user_email, INVITER_ID: "10000", INVITER_NAME: "some name"}])
       table_with_pk = Responsys::Api::Object::InteractObject.new("Some Test Folder", "some_supplementary_table")
       response = Responsys::Api::Client.instance.merge_table_records_with_pk(table_with_pk, record_data)
       expect(response[:status]).to eq("ok")
      end 
    end     
  end

  context "retrieve_profile_extension_records" do

    it "should set the status to ok" do
      VCR.use_cassette("api/profile_extension/retrieve_profile_extension_records") do
        response = Responsys::Api::Client.new.retrieve_profile_extension_records(@profile_extension, @query_column_riid, @fields, %W(#{@user_riid}))

        expect(response[:status]).to eq("ok")
      end
    end

    it "should return one record" do
      VCR.use_cassette("api/profile_extension/retrieve_profile_extension_records") do
        response = Responsys::Api::Client.new.retrieve_profile_extension_records(@profile_extension, @query_column_riid, @fields, %W(#{@user_riid}))

        expect(response[:data].length).to eq(1)
      end
    end

    it "should return two key-value pairs" do
      VCR.use_cassette("api/profile_extension/retrieve_profile_extension_records") do
        response = Responsys::Api::Client.new.retrieve_profile_extension_records(@profile_extension, @query_column_riid, @fields, %W(#{@user_riid}))

        expect(response[:data][0].length).to eq(2)
      end
    end

    it "should add (merge into) a profile extension member" do
      VCR.use_cassette("api/profile_extension/merge_profile_extension_records") do
        record_data = Responsys::Api::Object::RecordData.new([{RIID_: @user_riid, MONTHLY_PURCH: @user_purch}])
        response = Responsys::Api::Client.new.merge_into_profile_extension(@profile_extension, record_data, "RIID", true)

        expect(response[:status]).to eq("ok")
      end
    end

    it "should delete a profile extension member" do
      VCR.use_cassette("api/profile_extension/delete_profile_extension_records") do
        response = Responsys::Api::Client.new.delete_profile_extension_members(@profile_extension, @query_column_riid, %W{#{@user_riid}})

        expect(response[:status]).to eq("ok")
      end
    end

  end
end