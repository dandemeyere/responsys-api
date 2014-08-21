require "responsys/api/object/all"

module Responsys
  module Api
    module Campaign

      def trigger_message(campaign, recipients)
        raise "Recipients must be an array" unless recipients.is_a? Array
        message = {
          campaign: campaign.to_hash,
          recipientData: recipients.map(&:to_hash) 
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