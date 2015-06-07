module Responsys
  module Api
    class Authentication
      class << self
        attr_accessor :token
        attr_accessor :api_endpoint
      end

      def self.destroy
        self.token = nil
        self.api_endpoint = nil
      end

      def self.authenticated?
        self.token.present? && self.api_endpoint.present?
      end
    end
  end
end