require "spec_helper.rb"
require "responsys/api/client"

describe Responsys::Api::Object::CustomEvent do

  before(:all) do
    @eventName = "some_random_event"
    VCR.use_cassette("api/profile_extension/login") do
      Responsys::Api::Client.instance.login
    end    
  end

  context "new CustomEvent" do
    it "it should raise an exception if none of the eventName and eventId was passed" do
      expect{Responsys::Api::Object::CustomEvent.new}.to raise_exception(Responsys::Exceptions::ParameterException, "Either eventName or eventId parameters should be passed")
    end
    it "it should not raise an exception if one of the eventName and eventId was passed" do
      expect{Responsys::Api::Object::CustomEvent.new(@eventName)}.to_not raise_exception
    end    
  end
  
  context "trigger to recipients" do
    it "should succed for a valid custom event with valid recipients" do
        list = Responsys::Api::Object::InteractObject.new("Directory Outreach", "CONTACTS_LIST")
        recipient_data = Responsys::Api::Object::RecipientData.new(Responsys::Api::Object::Recipient.new({emailAddress: "sahil@healthtap.com", listName: list}), [Responsys::Api::Object::OptionalData.new("some_key" , "some_value")])
        custom_event = Responsys::Api::Object::CustomEvent.new("DirectoryPatientInvite")
        puts "gerererer"
        VCR.use_cassette("api/object/custom_event/trigger_to_recipients") do
        response = custom_event.trigger_to_recipients([recipient_data])
          expect(response[:status]).to eq("ok")
        end
    end
  end
end
