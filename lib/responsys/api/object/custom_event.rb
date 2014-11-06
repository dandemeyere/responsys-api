module Responsys
  module Api
    module Object
      class CustomEvent
        attr_accessor :event_name

        def initialize(event_name)
          @event_name = event_name
        end

        def to_api
          { eventName: @folder_name}
        end
      end
    end
  end
end