module Responsys
  module Api
    class Event < Responsys::Api::Resource
      attr_accessor :custom_event

      def resource_path
        "/rest/api/v1/events"
      end

      def initialize(custom_event)
        raise ParameterException.new("params.incorrect_event_object") unless custom_event.is_a?(CustomEvent)

        @custom_event = custom_event

        super()
      end

      def trigger(recipients)
        raise ParameterException.new("params.incorrect_recipients") unless Helpers.array_of?(recipients, RecipientData)

        body = {
          customEvent: @custom_event.to_api,
          recipientData: recipients.map(&:to_api)
        }

        self.post("/#{@custom_event.event_name}", { body: body })
      end
    end
  end
end
