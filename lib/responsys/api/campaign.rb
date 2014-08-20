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
        check_failures(outcome, recipients)
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