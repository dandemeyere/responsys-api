require "responsys/api/object/all"

module Responsys
  module Api
    module Event
      include Responsys::Exceptions
      def trigger_custom_event(custom_event, recipients)
        raise ParameterException, I18n.t("api.campaign.incorrect_recipients_type") unless recipients.is_a? Array
        message = {
          customEvent: custom_event.to_api,
          recipientData: recipients.map(&:to_api)
        }
        api_method(:trigger_custom_event, message)
      end
    end
  end
end

