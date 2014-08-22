require "spec_helper.rb"
require "responsys/api/client"

describe Responsys::Member do

  context "New member" do

    xit "should call mergeListMembers" do
    end

  end

  context "Adding member to list" do

    before(:each) do
      @connection = double "connection"
      allow(Responsys::Api::Client).to receive(:instance).and_return(@connection)

      @member = Responsys::Member.new("user@email.com")
      @list = Responsys::Api::Object::InteractObject.new("list_folder","list_object_name")
      @query_column = Responsys::Api::Object::QueryColumn.new("EMAIL_ADDRESS")
    end
    
    it "should pass the client a list InteractObject" do
      expect(@connection).to receive(:merge_list_members).with(be_a_kind_of(Responsys::Api::Object::InteractObject), anything, anything)
      @member.add_to_list(@list)
    end

    #delete
    it "should pass the client a RecordData object" do
      expect(@connection).to receive(:merge_list_members).with(anything, be_a_kind_of(Responsys::Api::Object::RecordData), anything)
      @member.add_to_list(@list)
    end
    #delete
    it "should pass the client a ListMergeRule object" do
      expect(@connection).to receive(:merge_list_members).with(anything, anything, be_a_kind_of(Responsys::Api::Object::ListMergeRule))
      @member.add_to_list(@list)
    end

    xit "should set EMAIL_PERMISSION_STATUS_ to 'O' if subscribe == false" do
    end
  end

  context "Subscribing" do

    before(:each) do
      @connection = double "connection"
      allow(Responsys::Api::Client).to receive(:instance).and_return(@connection)
      @member = Responsys::Member.new("test@email.com")
      @list = Responsys::Api::Object::InteractObject.new("list_folder","list_object_name")
    end

    it "should send update the correct subscribe data" do
      expect(@member).to receive(:update).with(@list, { EMAIL_ADDRESS_: @member.email, EMAIL_PERMISSION_STATUS_: "I" } )
      @member.subscribe(@list)
    end

    it "should check the user has subscribed" do
      response_expected = { status: "ok", data: [{ EMAIL_PERMISSION_STATUS_: "I" }] }
      allow(@connection).to receive(:retrieve_list_members).with(@list, kind_of(Responsys::Api::Object::QueryColumn), %w(EMAIL_PERMISSION_STATUS_), %W(#{@member.email})).and_return(response_expected)
    end

    it "should return false for unsubscribed member" do
      allow(@connection).to receive(:retrieve_list_members).and_return({:record_data=>{:field_names=>"EMAIL_PERMISSION_STATUS_", :records=>{:field_values=>"O"}}})
      expect(@member.subscribed?(@list)).to eql(false)
    end

    it "should return true for subscribed member" do
      allow(@connection).to receive(:retrieve_list_members).and_return({:record_data=>{:field_names=>"EMAIL_PERMISSION_STATUS_", :records=>{:field_values=>"I"}}})
      expect(@member.subscribed?(@list)).to eql(true)
    end

    it "should send update the correct unsubscribe data" do
      expect(@member).to receive(:update).with(@list, { EMAIL_ADDRESS_: @member.email, EMAIL_PERMISSION_STATUS_: "O" } )
      @member.unsubscribe(@list)
    end

  end

  context "Existing member" do

    before(:each) do
      @connection = double "connection"

      allow(Responsys::Api::Client).to receive(:instance).and_return(@connection)

      @member = Responsys::Member.new("user@email.com")
      @list = Responsys::Api::Object::InteractObject.new("list_folder","list_object_name")
    end

    xit "should check its existance to the list" do
    end

  end

  context "Get profile extension data" do

    before(:each) do
      VCR.use_cassette("member/login") do
        @profile_extension = Responsys::Api::Object::InteractObject.new("demo_folder2", "customers_extension")
        @member_without_riid = Responsys::Member.new("user@email.com")
        @member_with_riid = Responsys::Member.new("user@email.com", 398403)
        @fields = %w(RIID_ EMAIL_ADDRESS)
      end
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

        expect(response[:error][:message]).to eq(I18n.t("member.riid_missing"))
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