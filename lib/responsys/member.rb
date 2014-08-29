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

      @client.merge_list_members_riid(list, record, ListMergeRule.new(insertOnNoMatch: true, updateOnMatch: "NO_UPDATE"))
    end

    def retrieve_profile_extension(profile_extension, fields)
      return Responsys::Helper.format_response_with_message("member.riid_missing") if @user_riid.nil?
      return Responsys::Helper.format_response_with_message("member.record_not_found") unless present_in_profile?(profile_extension)

      @client.retrieve_profile_extension_records(profile_extension, QueryColumn.new("RIID"), fields, [@user_riid])
    end

    def subscribe(list)
      update(list, [{ EMAIL_ADDRESS_: @email, EMAIL_PERMISSION_STATUS_: "I" }])
    end

    def unsubscribe(list)
      update(list, [{ EMAIL_ADDRESS_: @email, EMAIL_PERMISSION_STATUS_: "O" }])
    end

    def update(list, data)
      return Responsys::Helper.format_response_with_message("member.record_not_found") unless present_in_list?(list)

      record = RecordData.new(data)
      @client.merge_list_members(list, record)
    end

    def present_in_profile?(list)
      return Responsys::Helper.format_response_with_message("member.riid_missing") if @user_riid.nil?

      response = lookup_profile_via_key(list, "RIID", @user_riid)

      !(response[:status] == "failure" && response[:error][:code] == "RECORD_NOT_FOUND")
    end

    def present_in_list?(list)
      if !@user_riid.nil?
        response = lookup_list_via_key(list, "RIID", @user_riid)
      else
        response = lookup_list_via_key(list, "EMAIL_ADDRESS", @email)
      end

      !(response[:status] == "failure" && response[:error][:code] == "RECORD_NOT_FOUND")
    end

    def subscribed?(list)
      return Responsys::Helper.format_response_with_message("member.record_not_found") unless present_in_list?(list)

      response = @client.retrieve_list_members(list, QueryColumn.new("EMAIL_ADDRESS"), %w(EMAIL_PERMISSION_STATUS_), [@email])
      response[:data][0][:EMAIL_PERMISSION_STATUS_] == "I"
    end

    private

    def lookup_profile_via_key(profile_extension, key, value)
      @client.retrieve_profile_extension_records(profile_extension, QueryColumn.new(key), %w(RIID_), [value])
    end

    def lookup_list_via_key(list, key, value)
      @client.retrieve_list_members(list, QueryColumn.new(key), %w(EMAIL_PERMISSION_STATUS_), [value])
    end
  end
end
