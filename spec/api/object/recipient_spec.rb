require "spec_helper.rb"

describe Responsys::Api::Object::Recipient do
  let(:recipient) { Responsys::Api::Object::Recipient.new }

  context "new recipient" do

    it "should have list_name attribute of type InteractObject" do
      expect(recipient.list_name).to be_nil
    end

    it "should have recipient_id attribute" do
      expect(recipient.recipient_id).to be_nil
    end

    it "should have customer_id attribute" do
      expect(recipient.customer_id).to be_nil
    end

    it "should have email_address attribute" do
      expect(recipient.email_address).to be_nil
    end

    it "should have mobile_number attribute" do
      expect(recipient.mobile_number).to be_nil
    end

    it "should have email_format attribute of type EmailFormat" do
      expect(recipient.email_format).to be_nil
    end

    it "should correctly transform the object" do
      expect(recipient.to_api).to eq(
        {
          listName: nil,
          recipientId: nil,
          customerId: nil,
          emailAddress: nil,
          mobileNumber: nil,
          emailFormat: nil
        }
      )
    end
  end
end
