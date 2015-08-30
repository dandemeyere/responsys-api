module Responsys
  class Session
    attr_accessor :token, :login_endpoint, :api_endpoint

    def initialize
      global_configuration = Responsys.configuration

      @login_endpoint = global_configuration.login_endpoint
      @credentials = global_configuration.api_credentials
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
  end
end