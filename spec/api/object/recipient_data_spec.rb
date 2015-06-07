require "spec_helper.rb"
require "responsys/api/client"

describe Responsys::Api::Object::RecipientData do 


  context "new RecipientData" do

    before(:each) do
      @recipient = Responsys::Api::Object::Recipient.new
      @recipient_data = Responsys::Api::Object::RecipientData.new(@recipient)
    end

    it "should have a recipient attribute of type Recipient" do
      expect(@recipient_data.recipient).to be_a(Responsys::Api::Object::Recipient)
    end

    it "should have a nil optional_data attribute by default" do
      expect(@recipient_data.optional_data).to be_nil
    end
  end


  context "RecipientData to_api method" do

    before(:each) do
      @recipient = Responsys::Api::Object::Recipient.new
      @recipient_data = Responsys::Api::Object::RecipientData.new(@recipient)
    end

    it "should be of type Hash" do
      expect(@recipient_data.to_api).to be_a(Hash)
    end

    it "should have a recipient attribute of type Hash" do
      expect(@recipient_data.to_api[:recipient]).to be_a(Hash)
    end

    it "should have a nil optionalData attribute" do
      expect(@recipient_data.to_api[:optionalData]).to be_nil
    end
  end
end
