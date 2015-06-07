require "spec_helper.rb"

describe Responsys::Api::Event do
  let(:list) { Responsys::Api::Object::InteractObject.new(DATA[:folder], DATA[:lists][:list1][:name]) }
  let(:campaign_name) { DATA[:campaigns][:campaign1][:name] }
  let(:recipient1) { Responsys::Api::Object::Recipient.new(emailAddress: DATA[:users][:user1][:EMAIL_ADDRESS], listName: list) }
  let(:recipient2) { Responsys::Api::Object::Recipient.new(emailAddress: DATA[:users][:user2][:EMAIL_ADDRESS], listName: list) }
  let(:recipientData1) { Responsys::Api::Object::RecipientData.new(recipient1) }
  let(:recipientData2) { Responsys::Api::Object::RecipientData.new(recipient2) }
  let(:campaign) { Responsys::Api::Campaign.new(campaign_name) }

  context "Trigger Message" do
    it "should return a status of ok when triggering a message for one recipient" do
      VCR.use_cassette("api/campaign/trigger_message_1") do
        response = campaign.trigger_email([recipientData1])
        expect(response.success?).to be_truthy
      end
    end

    it "should return a status of ok when triggering a message for more than one recipient" do
      VCR.use_cassette("api/campaign/trigger_message_2") do
        response = campaign.trigger_email([recipientData1, recipientData2])
        expect(response.success?).to be_truthy
      end
    end

    it "should pass api_method a message Hash" do
      expect(campaign).to receive(:api_method).with(anything, anything, be_a_kind_of(Hash))
      campaign.trigger_email([recipientData1])
    end

    it "should pass info to the trigger campaign message API call" do
      expect(campaign).to receive(:api_method).with(:post, "/rspec_campaign1/email", anything)
      campaign.trigger_email([recipientData1])
    end
  end
end