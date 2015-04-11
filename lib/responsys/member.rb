require "responsys/api/all"
require "responsys/api/object/all"

module Responsys
  class Member
    include Responsys::Api
    include Responsys::Api::Object
    attr_accessor :email, :user_riid, :client

    def initialize(email, riid = nil)
      @email = email
      @user_riid = riid
    end

    def add_to_list(list, subscribe = false, details = {}, update_record = false)
      data = { EMAIL_ADDRESS_:  @email, EMAIL_PERMISSION_STATUS_: subscribe ? "I" : "O" }

      safe_details = {}
      details.each do |k,v|
        next if reserved_fields.include? r_key(k)
        if [Time, Date, DateTime].include?(v.class)
          safe_details[r_key(k)] = details[k].strftime('%Y-%m-%dT%H:%M:%S%z')
        else
          safe_details[r_key(k)] = details[k]
        end
      end

      data = data.merge( safe_details )
      record = RecordData.new([data])

      Client.new.run do |client|
        client.merge_list_members_riid(list, record, ListMergeRule.new(insertOnNoMatch: true, updateOnMatch: (update_record ? 'REPLACE_ALL' : 'NO_UPDATE')))
      end
    end

    def retrieve_profile_extension(profile_extension, fields)
      Client.new.run do |client|
        return Responsys::Helper.format_response_with_message("member.riid_missing") if @user_riid.nil?
        return Responsys::Helper.format_response_with_message("member.record_not_found") unless present_in_profile?(profile_extension, true)

        client.retrieve_profile_extension_records(profile_extension, QueryColumn.new("RIID"), fields, [@user_riid])
      end
    end

    def subscribe(list)
      Client.new.run do |client|
        update(list, [{ EMAIL_ADDRESS_: @email, EMAIL_PERMISSION_STATUS_: "I" }])
      end
    end

    def unsubscribe(list)
      Client.new.run do |client|
        update(list, [{ EMAIL_ADDRESS_: @email, EMAIL_PERMISSION_STATUS_: "O" }])
      end
    end

    def update(list, data)
      Client.new.run(true) do |client|
        return Responsys::Helper.format_response_with_message("member.record_not_found") unless present_in_list?(list, true)

        record = RecordData.new(data)
        client.merge_list_members(list, record)
      end
    end

    def present_in_profile?(list, raising = false)
      Client.new.run(raising) do |client|
        return Responsys::Helper.format_response_with_message("member.riid_missing") if @user_riid.nil?

        response = lookup_profile_via_key(list, "RIID", @user_riid)

        !(response[:status] == "failure" && response[:error][:code] == "RECORD_NOT_FOUND")
      end
    end

    def present_in_list?(list, raising = false)
      Client.new.run(raising) do |client|
        if !@user_riid.nil?
          response = lookup_list_via_key(list, "RIID", @user_riid)
        else
          response = lookup_list_via_key(list, "EMAIL_ADDRESS", @email)
        end

        !(response[:status] == "failure" && response[:error][:code] == "RECORD_NOT_FOUND")
      end
    end

    def subscribed?(list, raising = false)
      Client.new.run(raising) do |client|
        return Responsys::Helper.format_response_with_message("member.record_not_found") unless present_in_list?(list, true)

        response = client.retrieve_list_members(list, QueryColumn.new("EMAIL_ADDRESS"), %w(EMAIL_PERMISSION_STATUS_), [@email])
        response[:data][0][:EMAIL_PERMISSION_STATUS_] == "I"
      end
    end

    private

    def r_key(k)
      k.to_s.upcase.to_sym
    end

    def reserved_fields
      # There are also the MOBILE and POSTAL fields.  We should allow those to be set via this method
      [
        :RIID_,
        :CREATED_SOURCE_IP_,
        :CUSTOMER_ID_,
        :EMAIL_ADDRESS_,
        :EMAIL_DOMAIN_,
        :EMAIL_ISP_,
        :EMAIL_FORMAT_,
        :EMAIL_PERMISSION_STATUS_,
        :EMAIL_DELIVERABILITY_STATUS_,
        :EMAIL_PERMISSION_REASON_,
      ]
    end

    def lookup_profile_via_key(profile_extension, key, value)
      Client.new.run(true) { |client| client.retrieve_profile_extension_records(profile_extension, QueryColumn.new(key), %w(RIID_), [value]) }
    end

    def lookup_list_via_key(list, key, value)
      Client.new.run(true) { |client| client.retrieve_list_members(list, QueryColumn.new(key), %w(EMAIL_PERMISSION_STATUS_), [value]) }
    end
  end
end
