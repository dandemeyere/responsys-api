require "spec_helper.rb"
require "responsys/api/client"

describe Responsys::Api::Campaign do
  let(:list) { Responsys::Api::Object::InteractObject.new(DATA[:folder], DATA[:lists][:list1][:name]) }
  let(:campaign) { Responsys::Api::Object::InteractObject.new(DATA[:folder], DATA[:campaigns][:campaign1][:name]) }
  let(:recipient1) { Responsys::Api::Object::Recipient.new(emailAddress: DATA[:users][:user1][:EMAIL_ADDRESS], listName: list) }
  let(:recipient2) { Responsys::Api::Object::Recipient.new(emailAddress: DATA[:users][:user2][:EMAIL_ADDRESS], listName: list) }
  let(:recipientData1) { Responsys::Api::Object::RecipientData.new(recipient1) }
  let(:recipientData2) { Responsys::Api::Object::RecipientData.new(recipient2) }
  let(:custom_event) { Responsys::Api::Object::CustomEvent.new(DATA[:custom_events][:custom_event1][:name]) }

  before(:all) do
    @client = Responsys::Api::Client.new
  end

  context "Trigger Message" do
    it "should return a status of ok when triggering a message for one recipient" do
      VCR.use_cassette("api/campaign/trigger_message_1") do
        response = Responsys::Api::Client.new.trigger_message(campaign, [recipientData1])
        expect(response.success?).to be_truthy
      end
    end

    it "should return a status of ok when triggering a message for more than one recipient" do
      VCR.use_cassette("api/campaign/trigger_message_2") do
        response = Responsys::Api::Client.new.trigger_message(campaign, [recipientData1,recipientData2])
        expect(response.success?).to be_truthy
      end
    end

    it "should pass api_method a message Hash" do
      expect(@client).to receive(:api_method).with(anything, be_a_kind_of(Hash))
      @client.trigger_message(campaign, [recipientData1])
    end

    it "should pass info to the trigger campaign message API call" do
      expect(@client).to receive(:api_method).with(:trigger_campaign_message, anything)
      @client.trigger_message(campaign, [recipientData1])
    end
  end

  context "#trigger_custom_event" do
    it "should return a status of ok when triggering a custom event for one recipient" do
      VCR.use_cassette("api/campaign/trigger_custom_event_1") do
        response = Responsys::Api::Client.new.trigger_custom_event(custom_event, [recipientData1])
        expect(response.success?).to be_truthy
      end
    end

    it "should return a status of ok when triggering a custom event for more than one recipient" do
      VCR.use_cassette("api/campaign/trigger_custom_event_2") do
        response = Responsys::Api::Client.new.trigger_custom_event(custom_event, [recipientData1,recipientData2])
        expect(response.success?).to be_truthy
      end
    end

    it "should pass api_method a message hash" do
      expect(@client).to receive(:api_method).with(anything, be_a_kind_of(Hash))
      @client.trigger_custom_event(custom_event, [recipientData1])
    end

    it "should pass info to the trigger custom event API call" do
      expect(@client).to receive(:api_method).with(:trigger_custom_event, anything)
      @client.trigger_custom_event(custom_event, [recipientData1])
    end

    it "should include a custom event in the message" do
      expect { @client.trigger_custom_event(campaign, [recipientData1]) }.to raise_error(Responsys::Exceptions::ParameterException, "custom_event must be a CustomEvent instance")
    end

    it "should only accept an array of recipients in the message" do
      expect { @client.trigger_custom_event(custom_event, recipientData1) }.to raise_error(Responsys::Exceptions::ParameterException, "Recipients parameter must be an array")
    end
  end
end