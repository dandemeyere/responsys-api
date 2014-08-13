require "spec_helper.rb"
require "responsys/api/client"

describe Responsys::Member do

  context "New member" do
    xit "should call mergeListMembers" do
    end
  end

  context "Subscribing" do
    before(:each) do
      @connection = double "connection"

      allow(Responsys::Api::Client).to receive(:instance).and_return(@connection)
      
      @member = Responsys::Member.new("user@email.com")
      @list = Responsys::Api::Object::InteractObject.new("list_folder","list_object_name")
    end

    xit "should check that the data provided is correct" do
    end

    it "should check the user has subscribed" do
      response_expected = { :record_data => { :field_names => "EMAIL_PERMISSION_STATUS_", :records => { :field_values=>"I" } } }
      
      allow(@connection).to receive(:retrieve_list_members).with(@list, "EMAIL_ADDRESS", %w(EMAIL_PERMISSION_STATUS_), %W(@member.email)).and_return(response_expected)

      expect(@member.subscribed?(@list)).to eq(true)
    end
  end

  context "Existing member" do
    before(:each) do
      @connection = double "connection"

      allow(Responsys::Api::Client).to receive(:instance).and_return(@connection)

      @member = Responsys::Member.new("user@email.com")
      @list = Responsys::Api::Object::InteractObject.new("list_folder","list_object_name")
    end

    xit "should check its existance to the list" do
    end
  end
end