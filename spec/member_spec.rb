require "spec_helper.rb"

describe Responsys::Member do

  before(:all) do
    @email = DATA[:users][:user1][:EMAIL_ADDRESS]
    @riid = DATA[:users][:user1][:RIID]
    @list = Responsys::Api::Object::InteractObject.new(DATA[:folder],DATA[:lists][:list1][:name])
  end

  context "Retrieve RIID" do
    it "should return the RIID" do
      VCR.use_cassette("member/retrieve_riid") do
        riid = Responsys::Member.new(@email).retrieve_riid(@list)

        expect(riid).to eq(@riid)
      end
    end

    it "should return nil if the user is not known" do
      VCR.use_cassette("member/retrieve_riid_unknown") do
        riid = Responsys::Member.new("totally.unknown.user@email.com").retrieve_riid(@list)

        expect(riid).to be_nil
      end
    end
  end

  context "New member" do
    before(:each) do
      @new_user_email = DATA[:users][:new_user4][:EMAIL_ADDRESS]
      @client = Responsys::Api::Client.new
      @member = Responsys::Member.new(@new_user_email, nil, @client)
      @list_double = double("list")
      allow(Responsys::Api::List).to receive(:new).with(@list).and_return(@list_double)
    end

    it "should call merge records on the list" do
      expect(@list_double).to receive(:merge_records).with(kind_of(Responsys::Api::Object::RecordData), kind_of(Responsys::Api::Object::ListMergeRule))

      @member.add_to_list(@list)
    end

  end

  context "Subscribing" do

    before(:each) do
      @member = Responsys::Member.new(@email)
      @query_column = Responsys::Api::Object::QueryColumn.new("EMAIL_ADDRESS")
    end

    it "should check the user is present in the list" do
      allow_any_instance_of(Responsys::Api::List).to receive(:merge_records)

      expect(@member).to receive(:present_in_list?).with(@list, true).and_return(true)

      @member.subscribe(@list)
    end

    it "should check the user has subscribed" do
      VCR.use_cassette("member/has_subscribed") do
        expect(@member.subscribed?(@list)).to eq(true)
      end
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

    it "should raise an exception if the record has not been found" do
      VCR.use_cassette("member/present5") do
        member_with_fake_riid = Responsys::Member.new(@email, "000001")

        expect{
          member_with_fake_riid.subscribed?(@list)
        }.to raise_error(Responsys::Exceptions::MemberNotFound, "The member has not been found in the list")
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

    it "should raise an exception if no riid provided" do
      VCR.use_cassette("member/retrieve_profile_extension_fail") do
        expect{
          @member_without_riid.retrieve_profile_extension(@list, @profile_extension, @fields)
        }.to raise_error(Responsys::Exceptions::ParameterException, "Variable riid is not provided to the member")
      end
    end

    it "should set the status to ok" do
      VCR.use_cassette("member/retrieve_profile_extension") do
        response = @member_with_riid.retrieve_profile_extension(@list, @profile_extension, @fields)

        expect(response.success?).to be_truthy
      end
    end

  end

  context "Disabled GEM" do
    before(:all) do
      Responsys.configuration.disable!(true)
    end

    after(:all) do
      Responsys.configuration.disable!(false)
    end

    it "should not make any call" do
      expect(HTTParty).to_not receive(:post)
    end

    it "should return disabled" do
      expect(Responsys::Member.new(@email).subscribe(@list)).to eq("disabled")
    end
  end
end
