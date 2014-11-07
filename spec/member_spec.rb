require "spec_helper.rb"
require "responsys/api/client"

describe Responsys::Member do

  before(:all) do
    @email = DATA[:users][:user1][:EMAIL_ADDRESS]
    @riid = DATA[:users][:user1][:RIID]
    @list = Responsys::Api::Object::InteractObject.new(DATA[:folder],DATA[:lists][:list1][:name])
  end

  context "New member" do

    xit "should call mergeListMembers" do
    end

  end

  context "Subscribing" do

    let(:connection) { double "connection" }
    before(:each) do
      allow(Responsys::Api::Client).to receive(:instance).and_return(connection)
      @member = Responsys::Member.new(@email)
      @query_column = Responsys::Api::Object::QueryColumn.new("EMAIL_ADDRESS")
    end

    it "should check the user is present in the list" do
      expect(@member).to receive(:present_in_list?).with(@list)

      @member.subscribe(@list)
    end

    it "should check the user has subscribed" do
      response_expected = { status: "ok", data: [{ EMAIL_PERMISSION_STATUS_: "I" }] }

      allow(connection).to receive(:retrieve_list_members).with(@list, kind_of(Responsys::Api::Object::QueryColumn), %w(EMAIL_PERMISSION_STATUS_), %W(#{@member.email})).and_return(response_expected)

      expect(@member.subscribed?(@list)).to eq(true)
    end

  end

  context "Existing member" do

    it "should be ok, the email is present" do
      VCR.use_cassette("member/present1") do
        member_without_riid = Responsys::Member.new(@email)
        bool = member_without_riid.present_in_list?(@list)

        expect(bool).to eq(true)
      end
    end

    it "should be ok, the email and riid is present" do
      VCR.use_cassette("member/present2") do
        member_with_riid = Responsys::Member.new(@email, @riid)
        bool = member_with_riid.present_in_list?(@list)

        expect(bool).to eq(true)
      end
    end

    it "should fail, the email is not present" do
      VCR.use_cassette("member/present3") do
        member_with_fake_email = Responsys::Member.new("thisemailis@notpresent.com")
        bool = member_with_fake_email.present_in_list?(@list)

        expect(bool).to eq(false)
      end
    end

    it "should fail, the email is present but not the riid" do
      VCR.use_cassette("member/present4") do
        member_with_fake_riid = Responsys::Member.new(@email, "000001")
        bool = member_with_fake_riid.present_in_list?(@list)

        expect(bool).to eq(false)
      end
    end

    it "should return the record_not_found code message" do
      VCR.use_cassette("member/present5") do
        member_with_fake_riid = Responsys::Member.new(@email, "000001")
        response = member_with_fake_riid.subscribed?(@list)

        expect(response[:error][:code]).to eq("record_not_found")
      end
    end

  end

  context "Get profile extension data" do

    before(:all) do
      @profile_extension = Responsys::Api::Object::InteractObject.new(DATA[:folder], DATA[:pets][:pet1][:name])
      @member_without_riid = Responsys::Member.new(@email)
      @member_with_riid = Responsys::Member.new(@email, @riid)
      @fields = %w(RIID_ MONTHLY_PURCH)
    end

    it "should set the status to failure if no riid provided" do
      VCR.use_cassette("member/retrieve_profile_extension_fail") do
        response = @member_without_riid.retrieve_profile_extension(@profile_extension, @fields)

        expect(response[:status]).to eq("failure")
      end
    end

    it "should set a i18n message in the response if no riid provided" do
      VCR.use_cassette("member/retrieve_profile_extension_fail") do
        response = @member_without_riid.retrieve_profile_extension(@profile_extension, @fields)

        expect(response[:error][:message]).to eq(Responsys::Helper.get_message("member.riid_missing"))
      end
    end

    it "should set the status to ok" do
      VCR.use_cassette("member/retrieve_profile_extension") do
        response = @member_with_riid.retrieve_profile_extension(@profile_extension, @fields)

        expect(response[:status]).to eq("ok")
      end
    end

  end
end
