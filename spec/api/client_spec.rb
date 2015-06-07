require "spec_helper.rb"

describe Responsys::Api::Client do
  describe "Disabled GEM" do
    before(:all) do
      Responsys.configuration.disable!(true)
    end

    after(:all) do
      Responsys.configuration.disable!(false)
    end

    it "should not make any call through an object" do
      email = DATA[:users][:user1][:EMAIL_ADDRESS]
      list = Responsys::Api::Object::InteractObject.new(DATA[:folder],DATA[:lists][:list1][:name])
      query_column = Responsys::Api::Object::QueryColumn.new("EMAIL_ADDRESS")

      expect(HTTParty).to_not receive(:post)
      expect(subject.lists(list).retrieve_record(query_column, %w(EMAIL_PERMISSION_STATUS_), email)).to eq("disabled")
    end
  end
end