require "spec_helper.rb"

describe Responsys::Api::Resource do
  let(:client) { Responsys::Api::Client.new }

  before(:context) do
    @list = Responsys::Api::Object::InteractObject.new(DATA[:folder], DATA[:lists][:list1][:name])
    @query_column_email = Responsys::Api::Object::QueryColumn.new("EMAIL_ADDRESS")
    @user1_email = DATA[:users][:user1][:EMAIL_ADDRESS]
    @user1_mobile = DATA[:users][:user1][:MOBILE_NUMBER]
    @user2_email = DATA[:users][:user2][:EMAIL_ADDRESS]
  end

  def retrieve_record
    client.lists(@list).retrieve_record(@query_column_email, %w(EMAIL_ADDRESS_ MOBILE_NUMBER_), @user1_email)
  end

  describe "Authentication" do

    describe "Failure" do
      before(:all) do
        set_incorrect_credentials
      end

      after(:all) do
        set_correct_credentials
      end

      it "should raise an exception if the credentials are incorrect" do
        VCR.use_cassette("api/resource/incorrect_credentials") do
          expect{
            retrieve_record
          }.to raise_error(Responsys::Exceptions::FailedAuthentication, "Invalid username or password")
        end
      end
    end

    describe "In-GEM session" do
      it "should make sure the token and api endpoint don't exist" do
        expect(Responsys::Api::Authentication.token).to be_nil
        expect(Responsys::Api::Authentication.api_endpoint).to be_nil
      end

      it "should make the first login auth and retrieve a record", stay_logged_in: true do
        VCR.use_cassette("api/resource/_in_gem_login_and_retrieve_first") do
          expect_any_instance_of(described_class).to receive(:authenticate!).once.and_call_original

          response = retrieve_record

          expect(response.success?).to be_truthy
        end
      end
      
      it "should have the authentication token set", stay_logged_in: true do
        expect(Responsys::Api::Authentication.token).to_not be_nil
      end

      it "should have the api endpoint set", stay_logged_in: true do
        expect(Responsys::Api::Authentication.api_endpoint).to_not be_nil
      end
      
      it "should be in the authenticated status", stay_logged_in: true do
        expect(Responsys::Api::Authentication.authenticated?).to be_truthy
      end

      it "should retrieve a record without making a login call" do
        VCR.use_cassette("api/resource/_in_gem_login_and_retrieve_second") do
          expect_any_instance_of(described_class).to_not receive(:authenticate!)

          response = retrieve_record

          expect(response.success?).to be_truthy
        end
      end
    end

  end

  describe "Disabled GEM" do
    before(:all) do
      Responsys.configuration.disable!(true)
    end

    after(:all) do
      Responsys.configuration.disable!(false)
    end

    it "shouldn't make an API call" do
      expect(HTTParty).to_not receive(:get)

      retrieve_record
    end

    it "should return 'disabled'" do
      expect(retrieve_record).to eq("disabled")
    end
  end
end