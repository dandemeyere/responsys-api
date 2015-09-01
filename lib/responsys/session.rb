require "securerandom"

module Responsys
  class Session
    attr_accessor :uuid, :token, :login_endpoint, :api_endpoint

    def initialize(data = {})
      global_configuration = Responsys.configuration

      @login_endpoint = data[:login_endpoint] || global_configuration.login_endpoint
      @credentials = data[:credentials] || global_configuration.api_credentials
      @token = data[:token]
      @uuid = data[:uuid] || SecureRandom.uuid
    end

    def authenticate!
      response = Api::Resource.make_call(:post, @login_endpoint, "/rest/api/v1/auth/token",
        {
          body: @credentials,
          headers: {
            "Content-Type" => "application/x-www-form-urlencoded"
          }
        }
      )

      raise Responsys::Exceptions::FailedAuthentication.new(response.error_title) if response.error?

      self.token = response.data[:authToken]
      self.api_endpoint = response.data[:endPoint]
    end

    def refresh_token!
      response = Api::Resource.make_call(:post, @login_endpoint, "/rest/api/v1/auth/token", { query: { auth_type: "token" } })

      raise Responsys::Exceptions::FailedAuthentication.new(response.error_title) if response.error?

      self.token = response.data[:authToken]
      self.api_endpoint = response.data[:endPoint]
    end

    def destroy
      self.token = nil
      self.api_endpoint = nil
    end

    def authenticated?
      self.token.present? && self.api_endpoint.present?
    end

    def data
      {
        uuid: @uuid,
        token: @token,
        login_endpoint: @login_endpoint,
        api_endpoint: @api_endpoint
      }
    end

    def to_json
      data.to_json
    end

    def self.from_json(session_data)
      self.new(JSON.parse(session_data, symbolize_names: true))
    end
  end
end