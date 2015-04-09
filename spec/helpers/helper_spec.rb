# encoding: UTF-8

require "spec_helper.rb"

describe Responsys::Helpers do

  context "Get i18n messages" do
    let(:message_key) { "member.record_not_found" }
    let(:message_key_thredup) { "thredup" }

    it "should get a message present in the en yml file" do
      I18n.locale = :en

      expect(Responsys::Helpers.get_message(message_key))
        .to eq("The member has not been found in the list")
    end

    it "should get the default locale message if locale is not present", i18n_test_files: true do
      I18n.locale = :de

      expect(Responsys::Helpers.get_message(message_key_thredup))
        .to eq("Think Secondhand First")
    end

    it "should get the message according to the active locale", i18n_test_files: true do
      I18n.locale = :de

      expect(Responsys::Helpers.get_message("hello"))
        .to eq("Guten Tag")
    end

    it "should return the default message", i18n_test_files: true do
      I18n.locale = :de

      expect(Responsys::Helpers.get_message(message_key))
        .to eq("Responsys - Unknown message 'member.record_not_found'")
    end

  end
end
