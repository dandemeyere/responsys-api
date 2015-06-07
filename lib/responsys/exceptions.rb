module Responsys
  module Exceptions
    class InternalException < Exception
      def initialize(message_key = nil)
        if message_key.nil?
          super
        else
          super(Responsys::Helpers.get_message(message_key))
        end
      end
    end

    class ConfigurationException < Responsys::Exceptions::InternalException
    end

    class ParameterException < Responsys::Exceptions::InternalException
    end

    class DisabledException < Responsys::Exceptions::InternalException
      def initialize
        super("gem_is_disabled")
      end
    end

    class MemberNotFound < Responsys::Exceptions::InternalException
      def initialize
        super("member.record_not_found")
      end
    end

    class ApiException < Exception
    end

    class FailedAuthentication < ApiException
    end
  end
end