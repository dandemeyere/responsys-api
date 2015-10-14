require "spec_helper.rb"

describe Responsys::Api::Event do
  let(:client) { Responsys::Api::Client.new }
  let(:list) { Responsys::Api::Object::InteractObject.new(DATA[:folder], DATA[:lists][:list1][:name]) }
  let(:campaign) { Responsys::Api::Object::InteractObject.new(DATA[:folder], DATA[:campaigns][:campaign1][:name]) }
  let(:recipient1) { Responsys::Api::Object::Recipient.new(emailAddress: DATA[:users][:user1][:EMAIL_ADDRESS], listName: list) }
  let(:recipient2) { Responsys::Api::Object::Recipient.new(emailAddress: DATA[:users][:user2][:EMAIL_ADDRESS], listName: list) }
  let(:recipientData1) { Responsys::Api::Object::RecipientData.new(recipient1) }
  let(:recipientData2) { Responsys::Api::Object::RecipientData.new(recipient2) }
  let(:custom_event) { Responsys::Api::Object::CustomEvent.new(DATA[:custom_events][:custom_event1][:name]) }
  let(:event) { Responsys::Api::Event.new(custom_event) }

  context "#trigger_custom_event" do
    it "should return a status of ok when triggering a custom event for one recipient" do
      VCR.use_cassette("api/event/trigger_custom_event_1") do
        response = client.events(custom_event).trigger([recipientData1])
        expect(response.success?).to be_truthy
      end
    end

    it "should return a status of ok when triggering a custom event for more than one recipient" do
      VCR.use_cassette("api/event/trigger_custom_event_2") do
        response = client.events(custom_event).trigger([recipientData1, recipientData2])
        expect(response.success?).to be_truthy
      end
    end

    it "should pass api_method a message hash" do
      expect(event).to receive(:api_method).with(:post, anything, be_a_kind_of(Hash))
      event.trigger([recipientData1])
    end

    it "should raise an exception if the init param is not a CustomEvent object" do
      expect { Responsys::Api::Event.new(campaign) }.to raise_error(Responsys::Exceptions::ParameterException, "The event must be of type CustomEvent")
    end

    it "should only accept an array of recipients in the message" do
      expect { client.events(custom_event).trigger(recipientData1) }.to raise_error(Responsys::Exceptions::ParameterException, "The record data must be an Array of RecipientData")
    end
  end
end
