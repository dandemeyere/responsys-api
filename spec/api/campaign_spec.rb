require "spec_helper.rb"
require "responsys/api/client"

describe Responsys::Api::Campaign do
  let(:campaign) { Responsys::Api::Object::InteractObject.new("fake","fake") }
  let(:recipient) { Responsys::Api::Object::Recipient.new(emailAddress: 'fake@thredup.com') }
  let(:recipientData) { Responsys::Api::Object::RecipientData.new(recipient) }
  let(:custom_event) { Responsys::Api::Object::CustomEvent.new("event_name") }

  before(:all) do
    @client = Responsys::Api::Client.instance
  end

  context "Trigger Message" do
    it "should pass api_method a message Hash" do
      expect(@client).to receive(:api_method).with(anything, be_a_kind_of(Hash))
      @client.trigger_message(campaign, [recipientData])
    end

    it "should pass info to the trigger campaign message API call" do
      expect(@client).to receive(:api_method).with(:trigger_campaign_message, anything)
      @client.trigger_message(campaign, [recipientData])
    end
  end

  context "#trigger_custom_event" do
    it "should pass api_method a message hash" do
      expect(@client).to receive(:api_method).with(anything, be_a_kind_of(Hash))
      @client.trigger_custom_event(custom_event, [recipientData])
    end

    it "should pass info to the trigger custom event API call" do
      expect(@client).to receive(:api_method).with(:trigger_custom_event, anything)
      @client.trigger_custom_event(custom_event, [recipientData])
    end

    it "should include a custom event in the message" do
      expect { @client.trigger_custom_event(campaign, [recipientData]) }.to raise_error(Responsys::Exceptions::ParameterException, "custom_event must be a CustomEvent instance")
    end

    it "should only accept an array of recipients in the message" do
      expect { @client.trigger_custom_event(custom_event, recipientData) }.to raise_error(Responsys::Exceptions::ParameterException, "Recipients parameter must be an array")
    end
  end
end