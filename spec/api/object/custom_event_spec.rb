require "spec_helper.rb"

describe Responsys::Api::Object::CustomEvent do
  context "#intialize" do
    it "should raise an exception if there is no event identifier present" do
      expect{ Responsys::Api::Object::CustomEvent.new("") }.to raise_exception(Responsys::Exceptions::ParameterException, "The event_name or event_id must be specified")
    end
  end

  context "#to_api" do
    it "should correctly transform the object to the api representation" do
      object = Responsys::Api::Object::CustomEvent.new("event_name")
      expect(object.to_api).to eq({ eventName: "event_name", eventId: nil, eventStringDataMapping: nil, eventDateDataMapping: nil, eventNumberDataMapping: nil })
    end
  end
end