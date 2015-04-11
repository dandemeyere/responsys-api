module Responsys
  module Exceptions
    class BaseException < Exception
      def initialize(message_key = nil)
        if message_key.nil?
          super
        else
          super(Responsys::Helper.get_message(message_key))
        end
      end
    end

    class ParameterException < Responsys::Exceptions::BaseException
    end

    class GenericException < Responsys::Exceptions::BaseException
    end
  end
end