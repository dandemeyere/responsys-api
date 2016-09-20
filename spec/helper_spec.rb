# encoding: UTF-8

require "spec_helper.rb"

describe Responsys::Helper do

  context "Get i18n messages" do
    let(:message_key) { "member.record_not_found" }
    let(:message_key_thredup) { "thredup" }

    it "should get a message present in the en yml file" do
      I18n.locale = :en

      expect(Responsys::Helper.get_message(message_key))
        .to eq("The member has not been found in the list")
    end

    it "should get the default locale message if locale is not present", i18n_test_files: true do
      I18n.locale = :de

      expect(Responsys::Helper.get_message(message_key_thredup))
        .to eq("Think Secondhand First")
    end

    it "should get the message according to the active locale", i18n_test_files: true do
      I18n.locale = :de

      expect(Responsys::Helper.get_message("hello"))
        .to eq("Guten Tag")
    end

    it "should return the default message", i18n_test_files: true do
      I18n.locale = :de

      expect(Responsys::Helper.get_message(message_key))
        .to eq("Responsys - Unknown message 'member.record_not_found'")
    end
  end

  describe '#format_response_with_error' do
    let(:nori) { Nori.new(:strip_namespaces => true, :convert_tags_to => lambda { |tag| tag.snakecase.to_sym }) }

    it 'will format a Savon::SOAPFault response' do
      fault_body = File.read File.expand_path "../fixtures/soap_fault.xml", __FILE__
      http_response = HTTPI::Response.new 500, {}, fault_body
      soap_fault = Savon::SOAPFault.new http_response, nori

      result = Responsys::Helper.format_response_with_errors(soap_fault)
      expect(result[:status]).to eq "failure"
      expect(result[:error][:http_status_code]).to eq 500
      expect(result[:error][:code]).to eq "soap:Server"
      expect(result[:error][:message]).to eq "Fault occurred while processing."
    end

    it 'will format a Savon::HTTPError' do
      http_response = HTTPI::Response.new 503, {}, "Service unavailable"
      http_error = Savon::HTTPError.new(http_response)
      result = Responsys::Helper.format_response_with_errors(http_error)

      expect(result[:status]).to eq "failure"
      expect(result[:error][:http_status_code]).to eq 503
      expect(result[:error][:message]).to eq "Service unavailable"
    end

    it 'will re-raise a unformattable Savon error' do
      unformattable_error = Savon::InvalidResponseError.new
      expect{
        Responsys::Helper.format_response_with_errors(unformattable_error)
      }.to raise_error(Savon::InvalidResponseError)
    end

  end

end
