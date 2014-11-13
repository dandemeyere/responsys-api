require "responsys/api/object/all"

module Responsys
  module Api
    module Campaign
      include Responsys::Exceptions

      def trigger_message(campaign, recipients)
        raise ParameterException, Responsys::Helper.get_message("api.campaign.incorrect_recipients_type") unless recipients.is_a? Array
        message = {
          campaign: campaign.to_api,
          recipientData: recipients.map(&:to_api)
        }
        api_method(:trigger_campaign_message, message)
      end

      def check_failures(outcome, recipients)
        if outcome.respond_to?(:each_index)
          outcome.each_index { |i| puts "failed:\n" + recipients[i][:recipient].to_s unless outcome[i][:success] }
        else
          puts "failed:\n" + recipients[:recipient].to_s unless outcome[:success]
        end
      end

      def merge_trigger_email(campaign, record_data, trigger_data, merge_rule)
        raise ParameterException, Responsys::Helper.get_message(("api.campaign.incorrect_trigger_data_type") unless trigger_data.is_a? Array
        message = {
          recordData: record_data.to_api,
          mergeRule: merge_rule.to_api,
          campaign: campaign.to_api,
          triggerData: trigger_data.map(&:to_api)
        }

        api_method(:merge_trigger_email, message)
      end
    end
  end
end
