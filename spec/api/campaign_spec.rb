require "spec_helper.rb"
require "responsys/api/client"

describe Responsys::Api::Campaign do 

  context "Trigger Message" do
    before(:all) do
      @client = Responsys::Api::Client.instance
    end

    before(:each) do
      @campaign = Responsys::Api::Object::InteractObject.new("fake","fake")
      @recipient = Responsys::Api::Object::Recipient.new(emailAddress: 'fake@thredup.com')
      @recipientData = Responsys::Api::Object::RecipientData.new(@recipient)
    end

    it "should pass api_method a message Hash" do
      expect(@client).to receive(:api_method).with(anything, be_a_kind_of(Hash))
      @client.trigger_message(@campaign, [@recipientData])
    end
  end

end