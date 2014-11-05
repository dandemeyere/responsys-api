# encoding: UTF-8

require "spec_helper.rb"

describe Responsys::Helper do

  context "Get i18n messages" do
    let(:message_key) { "member.record_not_found"  }
    before(:each) {
      I18n.locale = :en
    }

    it "should get a message present in the en yml file" do
      expect(Responsys::Helper.get_message(message_key))
        .to eq("The member has not been found in the list")
    end

    it "should get the default locale message if locale is not present" do
      I18n.locale = :not_available_locale
      expect(Responsys::Helper.get_message(message_key))
        .to eq("The member has not been found in the list")
    end

    it "should get the message according to the active locale" do
      I18n.locale = :fr
      expect(Responsys::Helper.get_message(message_key))
        .to eq("L'enregistrement n'a pas été trouvé dans la liste")
    end

  end
end
