module Responsys
  module Api
    class Campaign < Responsys::Api::Resource
      attr_accessor :campaign_name

      def resource_path
        "/rest/api/v1/campaigns"
      end

      def initialize(campaign_name)
        @campaign_name = campaign_name

        super()
      end

      def trigger_email(recipients)
        raise ParameterException.new("params.incorrect_recipients") unless Helpers.array_of?(recipients, RecipientData)

        body = {
          recipientData: recipients.map(&:to_api)
        }

        self.post("/#{@campaign_name}/email", { body: body })
      end

      def merge_and_trigger_email(recipients, trigger_data, merge_rule = ListMergeRule.new)
        raise ParameterException.new("params.incorrect_recipients") unless Helpers.array_of?(recipients, RecipientData)

        body = {
          recipientData: recipients.map(&:to_api),
          mergeRule: merge_rule.to_api,
          trigger_data: trigger_data
        }

        self.post("/#{@campaign_name}/email", { body: body })
      end

      def merge_and_trigger_sms(recipients, trigger_data, merge_rule = ListMergeRule.new)
        raise ParameterException.new("params.incorrect_recipients") unless Helpers.array_of?(recipients, RecipientData)

        body = {
          recipientData: recipients.map(&:to_api),
          mergeRule: merge_rule.to_api,
          trigger_data: trigger_data
        }

        self.post("/#{@campaign_name}/sms", { body: body })
      end
    end
  end
end
