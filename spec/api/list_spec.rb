require "spec_helper.rb"

describe Responsys::Api::List do

  before(:context) do
    @list = Responsys::Api::Object::InteractObject.new("another_test_folder", "test_list")
    @query_column_email = Responsys::Api::Object::QueryColumn.new("EMAIL_ADDRESS")
    @multiple_users_email = %w(user@email.com user2@email.com user3@email.com)
    @user1_email = "user@email.com"
    @user1_mobile = "0000000001"
    @user2_mobile = "0000000000"

    VCR.use_cassette("api/list/login") do
      Responsys::Api::Client.instance.login
    end
  end

  context "Retrieve info from list with multiple users" do

    it "should get a ok status" do
      VCR.use_cassette("api/list/retrieve") do
        response = Responsys::Api::Client.instance.retrieve_list_members(@list, @query_column_email, %w(EMAIL_ADDRESS_ MOBILE_NUMBER_), @multiple_users_email)

        expect(response[:status]).to eq("ok")
      end
    end

    it "should get a value from the data" do
      VCR.use_cassette("api/list/retrieve") do
        response = Responsys::Api::Client.instance.retrieve_list_members(@list, @query_column_email, %w(EMAIL_ADDRESS_ MOBILE_NUMBER_), @multiple_users_email)

        expect(response[:data][2][:EMAIL_ADDRESS_]).to eq("user2@email.com")
      end
    end

    it "should get a nil value" do
      VCR.use_cassette("api/list/retrieve") do
        response = Responsys::Api::Client.instance.retrieve_list_members(@list, @query_column_email, %w(EMAIL_ADDRESS_ MOBILE_NUMBER_), @multiple_users_email)

        expect(response[:data][1][:MOBILE_NUMBER_]).to be(nil)
      end
    end

    it "should return a single result" do
      VCR.use_cassette("api/list/retrieve_single") do
        response = Responsys::Api::Client.instance.retrieve_list_members(@list, @query_column_email, %w(EMAIL_ADDRESS_ MOBILE_NUMBER_), [@user1_email])

        expect(response[:data][0][:EMAIL_ADDRESS_]).to eq(@user1_email)
      end
    end

    it "should return a single field in a single record" do
      VCR.use_cassette("api/list/retrieve_single_single") do
        response = Responsys::Api::Client.instance.retrieve_list_members(@list, @query_column_email, %w(EMAIL_ADDRESS_), [@user1_email])

        expect(response[:data][0][:EMAIL_ADDRESS_]).to eq(@user1_email)
      end
    end
  end

  context "Merge list members" do
    it "should reject no record" do
      VCR.use_cassette("api/list/merge") do
        data = [{ Email_Address_: @user1_email, Mobile_Number_: @user1_mobile }, { Mobile_Number_: @user2_mobile, Customer_ID_: "" }]
        response = Responsys::Api::Client.instance.merge_list_members(@list, Responsys::Api::Object::RecordData.new(data), merge_rule = Responsys::Api::Object::ListMergeRule.new(matchColumnName1: "Mobile_Number_"))

        expect(response[:data][0][:result][:rejected_count].to_i).to eq(0)
      end
    end
  end
end