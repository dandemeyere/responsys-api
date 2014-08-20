require "responsys/api/object/all"

module Responsys
  module Api
    module Campaign

      def trigger_message(campaign, recipients)
        recipients = hash_recipients(recipients)
        message = {
          campaign: campaign.to_hash,
          recipientData: recipients 
        }
        outcome = api_method(:trigger_campaign_message, message)
        check_errors(outcome, recipients)
      end

      def hash_recipients(recipients)
        if recipients.respond_to?(:each)
          hashedRecipients = []
          recipients.each { |recipient| hashedRecipients<<recipient.to_hash }
          recipients = hashedRecipients
        else
          recipients = recipients.to_hash
        end
        recipients
      end
      
      def check_errors(outcome, recipients)
        outcome.each_index { |i| puts recipients[i] unless outcome[i][:success] }
      end
    end
  end
end