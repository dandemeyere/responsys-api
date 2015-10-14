module Responsys
  module Api
    class Campaign < Responsys::Api::Resource
      include Responsys::Exceptions
      include Responsys::Api::Object

      attr_accessor :campaign_name

      def resource_path
        "/rest/api/v1/campaigns"
      end

      def initialize(campaign_name)
        @campaign_name = campaign_name

        super()
      end

      def trigger_email(recipients)
        raise ParameterException.new("api.campaign.incorrect_recipients_type") unless array_of_recipient_data?(recipients)

        body = {
          recipientData: recipients.map(&:to_api)
        }

        self.post("/#{@campaign_name}/email", { body: body })
      end

      def merge_and_trigger_email(recipients, trigger_data, merge_rule = ListMergeRule.new)
        raise ParameterException.new("api.campaign.incorrect_recipients_type") unless array_of_recipient_data?(recipients)

        body = {
          recipientData: recipients.map(&:to_api),
          mergeRule: merge_rule.to_api,
          trigger_data: trigger_data
        }

        self.post("/#{@campaign_name}/email", { body: body })
      end

      def merge_and_trigger_sms(recipients, trigger_data, merge_rule = ListMergeRule.new)
        raise ParameterException.new("api.campaign.incorrect_recipients_type") unless array_of_recipient_data?(recipients)

        body = {
          recipientData: recipients.map(&:to_api),
          mergeRule: merge_rule.to_api,
          trigger_data: trigger_data
        }

        self.post("/#{@campaign_name}/sms", { body: body })
      end

      private

      def array_of_recipient_data?(recipients)
        recipients.is_a?(Array) && recipients.all? { |element| element.is_a?(RecipientData) }
      end
    end
  end
end
