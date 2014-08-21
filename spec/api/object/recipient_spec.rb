require "spec_helper.rb"
require "responsys/api/client"

describe Responsys::Api::Object::Recipient do 


  context "new recipient" do

    before(:each) do
      @recipient = Responsys::Api::Object::Recipient.new
    end

    it "should have list_name attribute of type InteractObject" do
      expect(@recipient.list_name).to be_a(Responsys::Api::Object::InteractObject)
    end

    it "should have recipient_id attribute" do
      expect(@recipient.recipient_id).to be
    end

    it "should have customer_id attribute" do
      expect(@recipient.customer_id).to be
    end

    it "should have email_address attribute" do
      expect(@recipient.email_address).to be
    end

    it "should have mobile_number attribute" do
      expect(@recipient.mobile_number).to be
    end

    it "should have email_format attribute of type EmailFormat" do
      expect(@recipient.email_format).to be_a(Responsys::Api::Object::EmailFormat)
    end
  end

  context "recipient to_api" do

    before(:each) do
      @recipient = Responsys::Api::Object::Recipient.new
    end

    it "should have listName attribute of type Hash" do
      expect(@recipient.to_api[:listName]).to be_a(Hash)
    end

    it "should have recipientId attribute " do
      expect(@recipient.to_api[:recipientId]).to be
    end

    it "should have customerId attribute " do
      expect(@recipient.to_api[:customerId]).to be
    end

    it "should have emailAddress attribute " do
      expect(@recipient.to_api[:emailAddress]).to be
    end

    it "should have mobileNumber attribute " do
      expect(@recipient.to_api[:mobileNumber]).to be
    end

    it "should have EmailFormat attribute of type String" do
      expect(@recipient.to_api[:emailFormat]).to be_a(String)
    end
  end
end
