require "spec_helper.rb"

describe Responsys::Api::List do

  before(:context) do
    @list = Responsys::Api::Object::InteractObject.new("another_test_folder", "test_list")
    @query_column_email = Responsys::Api::Object::QueryColumn.new("EMAIL_ADDRESS")
    @multiple_users_email = %w(user@email.com user2@email.com user3@email.com)

    VCR.use_cassette("api/list/login") do
      Responsys::Api::Client.instance.login
    end
  end

  context "Retrieve info from list" do

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
  end

  context "Merge list members" do
    it "should" do
      VCR.use_cassette("api/list/retrieve") do
        data = [{ field1: "value11", field2: "value12" }, { field1: "value21", field2: "value22", field3: "value23" }]

        response = Responsys::Api::Client.instance.merge_list_members(@list, Responsys::Api::Object::RecordData.new(data), merge_rule = Responsys::Api::Object::ListMergeRule.new)

        expect(response[:status]).to eq("ok")
      end
    end
  end
end