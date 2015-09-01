require "spec_helper.rb"

describe Responsys::SessionPool do
  describe "Internal" do

  end

  describe "Redis", connection_pool: :redis do
    let(:client) { Responsys::Api::Client.new }

    before(:context) do
      @list = Responsys::Api::Object::InteractObject.new(DATA[:folder], DATA[:lists][:list1][:name])
      @query_column_email = Responsys::Api::Object::QueryColumn.new("EMAIL_ADDRESS")
      @user1_email = DATA[:users][:user1][:EMAIL_ADDRESS]
      @user1_mobile = DATA[:users][:user1][:MOBILE_NUMBER]
      @user2_email = DATA[:users][:user2][:EMAIL_ADDRESS]
    end

    context "Retrieve info from list with multiple users" do
      it "should just work" do
        VCR.use_cassette("api/list/retrieve_record") do
          response = client.lists(@list).retrieve_record(@query_column_email, %w(EMAIL_ADDRESS_ MOBILE_NUMBER_), @user1_email)

          expect(response.success?).to be_truthy
        end
      end
    end
  end
end
