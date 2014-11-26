module Responsys
  module Api
    module Object
      class CustomEvent
        attr_accessor :event_name, :event_id, :event_string_data_mapping, :event_date_data_mapping, :event_number_data_mapping, :client
        def initialize(event_name = "",  event_id ="" , event_string_data_mapping = "", event_date_data_mapping = "", event_number_data_mapping = "")
          @event_name = event_name
          @event_id = event_id
          raise ParameterException, I18n.t("api.object.custom_event.one_of_event_name_or_event_id_is_required") if @event_name.blank? and @event_id.blank?
          @event_string_data_mapping = event_string_data_mapping
          @event_date_data_mapping = event_date_data_mapping
          @event_number_data_mapping = event_number_data_mapping
          @client = Client.instance
        end

        def to_api
          { eventName: @event_name , eventId: @event_id , eventStringDataMapping: @event_string_data_mapping, eventDateDataMapping: @event_date_data_mapping , eventNumberDataMapping: @event_number_data_mapping}
        end

        def trigger_to_recipients(recipient_data)
          message = { customEvent: self.to_api, recipientData: recipient_data.map(&:to_api)}
          @client.api_method(:trigger_custom_event, message)
        end
      end
    end
  end
end
