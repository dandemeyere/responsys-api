module Responsys
  module Api
    module Object
      class CustomEvent
        include Responsys::Exceptions
        attr_accessor :event_name, :event_id, :event_string_data_mapping, :event_number_data_mapping, :event_date_data_mapping

        def initialize(event_name="", event_id="", options={})
          raise ParameterException, Responsys::Helper.get_message("api.object.custom_event.empty_event") if event_name.blank? && event_id.blank?
          @event_name = event_name || ""
          @event_id = event_id || ""
          @event_string_data_mapping = options[:event_string_data_mapping] || ""
          @event_number_data_mapping = options[:event_number_data_mapping] || ""
          @event_date_data_mapping = options[:event_date_data_mapping] || ""
        end

        def to_api
          {
            eventName: event_name,
            eventId: event_id,
            eventStringDataMapping: event_string_data_mapping,
            eventDateDataMapping: event_date_data_mapping,
            eventNumberDataMapping: event_number_data_mapping
           }
        end
      end
    end
  end
end