require "spec_helper.rb"

describe Responsys::Api::Client do

  describe "Authentication methods" do
    it "should refuse the access to api_method for logout" do
        expect{ subject.api_method(:logout) }.to raise_error("Please use the dedicated logout method")
    end

    it "should refuse the access to api_method for login" do
      expect{ subject.api_method(:login) }.to raise_error("Please use the dedicated login method")
    end
  end

  describe "Disabled GEM" do
    before(:all) do
      Responsys.configure { |config| config.settings[:enabled] = false }
    end

    after(:all) do
      Responsys.configure { |config| config.settings[:enabled] = true }
    end

    it "should not make any call" do
      email = DATA[:users][:user1][:EMAIL_ADDRESS]
      list = Responsys::Api::Object::InteractObject.new(DATA[:folder],DATA[:lists][:list1][:name])
      query_column = Responsys::Api::Object::QueryColumn.new("EMAIL_ADDRESS")

      expect_any_instance_of(Responsys::Api::SessionPool).to_not receive(:with)
      expect(subject.retrieve_list_members(list, query_column, %w(EMAIL_PERMISSION_STATUS_), [email])).to eq("disabled")
    end
  end
end