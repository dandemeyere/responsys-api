module Responsys
  module Api
    class Event < Responsys::Api::Resource
      include Responsys::Api::Object
      include Responsys::Exceptions

      attr_accessor :custom_event

      def resource_path
        "/rest/api/v1/events"
      end

      def initialize(custom_event)
        raise ParameterException.new("api.event.incorrect_event_object") unless custom_event.is_a?(CustomEvent)

        @custom_event = custom_event

        super()
      end

      def trigger(recipients)
        raise ParameterException.new("api.event.incorrect_recipients_type") unless array_of_recipient_data?(recipients)

        body = {
          customEvent: @custom_event.to_api,
          recipientData: recipients.map(&:to_api)
        }

        self.post("/#{@custom_event.event_name}", { body: body })
      end

      private

      def array_of_recipient_data?(recipients)
        recipients.is_a?(Array) && recipients.all? { |element| element.is_a?(RecipientData) }
      end
    end
  end
end
