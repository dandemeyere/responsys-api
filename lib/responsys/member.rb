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
      return Responsys::Helper.format_response_with_message("member.record_not_found") unless present?(list)

      data = { EMAIL_ADDRESS_:  @email, EMAIL_PERMISSION_STATUS_: subscribe ? "I" : "O" }
      record = RecordData.new([data])

      @client.merge_list_members_riid(list, record, ListMergeRule.new(insertOnNoMatch: true, updateOnMatch: "NO_UPDATE"))
    end

    def retrieve_profile_extension(profile_extension, fields)
      return Responsys::Helper.format_response_with_message("member.riid_missing") if @user_riid.nil?
      return Responsys::Helper.format_response_with_message("member.record_not_found") unless present?(profile_extension)

      @client.retrieve_profile_extension_records(profile_extension, QueryColumn.new("RIID"), fields, [@user_riid])
    end

    def subscribe(list)
      update(list, [{ EMAIL_ADDRESS_: @email, EMAIL_PERMISSION_STATUS_: "I" }])
    end

    def unsubscribe(list)
      update(list, [{ EMAIL_ADDRESS_: @email, EMAIL_PERMISSION_STATUS_: "O" }])
    end

    def update(list, data)
      return Responsys::Helper.format_response_with_message("member.record_not_found") unless present?(list)

      record = RecordData.new(data)
      @client.merge_list_members(list, record)
    end

    def present?(list)
      response = @client.retrieve_list_members(list, QueryColumn.new("EMAIL_ADDRESS"), %w(EMAIL_PERMISSION_STATUS_), [@email])

      return false if response[:status] == "failure" && response[:error][:code] == "RECORD_NOT_FOUND"

      unless @user_riid.nil?
        response = @client.retrieve_list_members(list, QueryColumn.new("RIID"), %w(EMAIL_PERMISSION_STATUS_), [@user_riid])

        return false if response[:status] == "failure" && response[:error][:code] == "RECORD_NOT_FOUND"
      end

      true
    end

    def subscribed?(list)
      return Responsys::Helper.format_response_with_message("member.record_not_found") unless present?(list)

      response = @client.retrieve_list_members(list, QueryColumn.new("EMAIL_ADDRESS"), %w(EMAIL_PERMISSION_STATUS_), [@email])
      response[:data][0][:EMAIL_PERMISSION_STATUS_] == "I"
    end
  end
end
