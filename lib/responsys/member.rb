require "responsys/api/all"
require "responsys/api/object/all"

module Responsys
  class Member
    include Responsys::Api
    include Responsys::Api::Object
    attr_accessor :email, :user_riid

    def initialize(email, riid = nil)
      @email = email
      @user_riid = riid
      @client = Client.instance
    end

    def add_to_list(list, subscribe = false)
      data = { EMAIL_ADDRESS_:  @email, EMAIL_PERMISSION_STATUS_: subscribe ? "I" : "O" }
      record = RecordData.new([data])
      @client.merge_list_members(list, record, ListMergeRule.new(insertOnNoMatch: true, updateOnMatch: "NO_UPDATE"))
    end

    def update(list, data)
      record = RecordData.new(data)
      @client.merge_list_members(list, record)
    end

    def subscribe(list)
      update(list, [{ EMAIL_ADDRESS_: @email, EMAIL_PERMISSION_STATUS_: "I" }])
    end

    def subscribed?(list)
      response = @client.retrieve_list_members(list, QueryColumn.new("EMAIL_ADDRESS"), %w(EMAIL_PERMISSION_STATUS_), [@email])
      response[:data][0][:EMAIL_PERMISSION_STATUS_] == "I"
    end

    def unsubscribe(list)
      update(list, [{ EMAIL_ADDRESS_: @email, EMAIL_PERMISSION_STATUS_: "O" }])
    end

    def retrieve_profile_extension(profile_extension, fields)
      return Responsys::Helper.format_response_with_message("member.riid_missing") if @user_riid.nil?
      @client.retrieve_profile_extension_records(profile_extension, QueryColumn.new("RIID"), fields, [@user_riid])
    end
  end
end
