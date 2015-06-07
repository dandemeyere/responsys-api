require "spec_helper.rb"

describe Responsys::Api::Table do
  let(:client) { Responsys::Api::Client.new }

  before(:example) do
    @profile_extension = Responsys::Api::Object::InteractObject.new(DATA[:folder], DATA[:pets][:pet1][:name])
    @query_column_riid = Responsys::Api::Object::QueryColumn.new("RIID")
    @fields = %w(RIID_ MONTHLY_PURCH)
    @user_riid = DATA[:users][:user1][:RIID]
    @user_purch = DATA[:pets][:pet1][:records][:user1][:MONTHLY_PURCH]
    @supplement_table_folder = DATA[:supplement_tables][:supplement_table1][:folder_name]
    @supplement_table_name = DATA[:supplement_tables][:supplement_table1][:name]
    @table = Responsys::Api::Object::InteractObject.new(@supplement_table_folder , @supplement_table_name)
    @pet_id = DATA[:pets][:pet1][:id]
    @pet_name = DATA[:pets][:pet1][:name]
    @user_email = DATA[:users][:user1][:EMAIL_ADDRESS]
    @user2_email = DATA[:users][:user2][:EMAIL_ADDRESS]
  end

  ##Because there's no delete_table API, be careful if you try
  ##to call that without VCR and manually emptying your test folder.
  it "should create a table" do
    VCR.use_cassette("api/table/create_table") do
      new_table = Responsys::Api::Object::InteractObject.new(DATA[:folder], "table_temp_#{Time.now.to_i}")
      fields = [
        Responsys::Api::Object::Field.new("field1", Responsys::Api::Object::FieldType.new("STR500"), custom = false, data_extraction_key = false),
        Responsys::Api::Object::Field.new("field2", Responsys::Api::Object::FieldType.new("NUMBER"), custom = false, data_extraction_key = false),
        Responsys::Api::Object::Field.new("field3", Responsys::Api::Object::FieldType.new("TIMESTAMP"), custom = false, data_extraction_key = false),
      ]
      response = client.tables(new_table).create_table(fields, %w(field1))

      expect(response.success?).to be_truthy
    end
  end

  it "should merge table records using a primary key" do
    VCR.use_cassette("api/table/merge_records_pk") do
      record_data = Responsys::Api::Object::RecordData.new([{ EMAIL_ADDRESS: @user_email, PET_ID: @pet_id, PET_NAME: @pet_name }])

      response = client.tables(@table).merge_records_with_pk(record_data)

      expect(response.success?).to be_truthy
      expect(response.data[:errorMessage]).to be_nil
    end
  end

  it "should merge table records" do
    VCR.use_cassette("api/table/merge_records") do
      record_data = Responsys::Api::Object::RecordData.new([{ EMAIL_ADDRESS: @user2_email, PET_ID: @pet_id, PET_NAME: @pet_name }])

      response = client.tables(@table).merge_records(record_data, %w(EMAIL_ADDRESS))

      expect(response.success?).to be_truthy
      expect(response.data[:errorMessage]).to be_nil
    end
  end
end