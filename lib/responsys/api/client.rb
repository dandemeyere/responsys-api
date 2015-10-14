module Responsys
  module Api
    class Client
      include Responsys::Api::All
      include Responsys::Exceptions

      class << self
        attr_accessor :raise_exceptions
      end

      def initialize
        self.class.raise_exceptions ||= false
      end

      def run(exception_raising = false)
        old_raise_exceptions = self.class.raise_exceptions
        self.class.raise_exceptions = exception_raising
        begin
          yield(self)
        rescue DisabledException => e
          raise e if self.class.raise_exceptions
          "disabled"
        ensure
          self.class.raise_exceptions = old_raise_exceptions
        end
      end
    end
  end
end
