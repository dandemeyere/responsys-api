module Responsys
  class Member
    include Responsys::Exceptions
    include Responsys::Api::Object
    attr_accessor :email, :user_riid, :client

    def initialize(email, riid = nil, client = Responsys::Api::Client.new)
      @email = email
      @user_riid = riid
      @client = client
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

      data = data.merge(safe_details)
      record_data = RecordData.new([data])

      @client.run do |client|
        client.lists(list).merge_records(record_data, ListMergeRule.new(insertOnNoMatch: true, updateOnMatch: (update_record ? 'REPLACE_ALL' : 'NO_UPDATE')))
      end
    end

    def retrieve_riid(list)
      @client.run do |client|
        response = @client.lists(list).retrieve_record(QueryColumn.new("EMAIL_ADDRESS"), %w(RIID_), @email)

        return nil if response.error?

        response.data[0][:RIID_].to_i
      end
    end

    def retrieve_profile_extension(list, profile_extension, fields)
      @client.run do |client|
        raise ParameterException.new("member.riid_missing") if @user_riid.nil?
        raise MemberNotFound unless present_in_profile?(list, profile_extension, true)

        client.lists(list).extensions(profile_extension).retrieve_record(QueryColumn.new("RIID"), fields, @user_riid)
      end
    end

    def subscribe(list)
      @client.run do |client|
        update(list, [{ EMAIL_ADDRESS_: @email, EMAIL_PERMISSION_STATUS_: "I" }])
      end
    end

    def unsubscribe(list)
      @client.run do |client|
        update(list, [{ EMAIL_ADDRESS_: @email, EMAIL_PERMISSION_STATUS_: "O" }])
      end
    end

    def update(list, data)
      @client.run(true) do |client|
        raise ApiException.new("member.record_not_found") unless present_in_list?(list, true)

        record = RecordData.new(data)
        client.lists(list).merge_records(record)
      end
    end

    def present_in_profile?(list, extension, raising = false)
      @client.run(raising) do |client|
        raise ParameterException.new("member.riid_missing") if @user_riid.nil?

        response = lookup_profile_via_key(list, extension, "RIID", @user_riid)

        !(response.error? && response.error_code == "RECORD_NOT_FOUND")
      end
    end

    def present_in_list?(list, raising = false)
      @client.run(raising) do |client|
        if !@user_riid.nil?
          response = lookup_list_via_key(list, "RIID", @user_riid)
        else
          response = lookup_list_via_key(list, "EMAIL_ADDRESS", @email)
        end

        !(response.error? && response.error_code == "RECORD_NOT_FOUND")
      end
    end

    def subscribed?(list, raising = false)
      @client.run(raising) do |client|
        raise MemberNotFound unless present_in_list?(list, true)

        response = @client.lists(list).retrieve_record(QueryColumn.new("EMAIL_ADDRESS"), %w(EMAIL_PERMISSION_STATUS_), @email)
        response.data[0][:EMAIL_PERMISSION_STATUS_] == "I"
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

    def lookup_profile_via_key(list, profile_extension, key, value)
      @client.run(true) { |client| client.lists(list).extensions(profile_extension).retrieve_record(QueryColumn.new(key), %w(RIID_), value) }
    end

    def lookup_list_via_key(list, key, value)
      @client.run(true) { |client| client.lists(list).retrieve_record(QueryColumn.new(key), %w(EMAIL_PERMISSION_STATUS_), value) }
    end
  end
end
