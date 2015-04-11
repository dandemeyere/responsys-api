require "responsys/api/object/all"

module Responsys
  module Api
    module Campaign
      include Responsys::Exceptions

      def trigger_custom_event(custom_event, recipients)
        raise ParameterException.new("api.campaign.incorrect_recipients_type") unless recipients.is_a? Array
        raise ParameterException.new("api.object.custom_event.incorrect_event_object") unless custom_event.is_a? Responsys::Api::Object::CustomEvent

        message = {
          customEvent: custom_event.to_api,
          recipientData: recipients.map(&:to_api)
        }
        api_method(:trigger_custom_event, message)
      end

      def trigger_message(campaign, recipients)
        raise ParameterException.new("api.campaign.incorrect_recipients_type") unless recipients.is_a? Array
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
    end
  end
end
