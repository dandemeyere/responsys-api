require "spec_helper.rb"

describe Responsys::Api::List do
  let(:client) { Responsys::Api::Client.new }

  before(:context) do
    @list = Responsys::Api::Object::InteractObject.new(DATA[:folder], DATA[:lists][:list1][:name])
    @query_column_email = Responsys::Api::Object::QueryColumn.new("EMAIL_ADDRESS")
    @user1_email = DATA[:users][:user1][:EMAIL_ADDRESS]
    @user1_mobile = DATA[:users][:user1][:MOBILE_NUMBER]
    @user2_email = DATA[:users][:user2][:EMAIL_ADDRESS]
  end

  context "Retrieve info from list with multiple users" do

    it "should get a ok status" do
      VCR.use_cassette("api/list/retrieve_record") do
        response = client.lists(@list).retrieve_record(@query_column_email, %w(EMAIL_ADDRESS_ MOBILE_NUMBER_), @user1_email)

        expect(response.success?).to be_truthy
      end
    end

    it "should get a value from the data" do
      VCR.use_cassette("api/list/retrieve_record") do
        response = client.lists(@list).retrieve_record(@query_column_email, %w(EMAIL_ADDRESS_ MOBILE_NUMBER_), @user1_email)

        expect(response.data[0][:MOBILE_NUMBER_]).to eq(@user1_mobile)
      end
    end

    it "should get a nil value" do
      VCR.use_cassette("api/list/retrieve_record_user2") do
        response = client.lists(@list).retrieve_record(@query_column_email, %w(EMAIL_ADDRESS_ MOBILE_NUMBER_), @user2_email)

        expect(response.data[0][:MOBILE_NUMBER_]).to be(nil)
      end
    end
  end

  context "Merge list members" do
    it "should have a successful response" do
      VCR.use_cassette("api/list/merge_records") do
        data = [{ EMAIL_ADDRESS_: @user1_email, MOBILE_NUMBER_: @user1_mobile }]
        response = client.lists(@list).merge_records(Responsys::Api::Object::RecordData.new(data), merge_rule = Responsys::Api::Object::ListMergeRule.new(matchColumnName1: "MOBILE_NUMBER_"))

        expect(response.success?).to be_truthy
      end
    end

    it "should have no reject" do
      VCR.use_cassette("api/list/merge_records") do
        data = [{ EMAIL_ADDRESS_: @user1_email, MOBILE_NUMBER_: @user1_mobile }]
        response = client.lists(@list).merge_records(Responsys::Api::Object::RecordData.new(data), merge_rule = Responsys::Api::Object::ListMergeRule.new(matchColumnName1: "MOBILE_NUMBER_"))

        expect(response.data[:rejected_count].to_i).to eq(0)
      end
    end
  end
end