module Responsys
  module Api
    module Session
      def login
        response = run("login", credentials)
        establish_session_id(response)
        establish_jsession_id(response)
        set_session_credentials
      end

      def logout
        api_method(:logout)
      end

      private

      def establish_session_id(login_response)
        @session_id = login_response.body[:login_response][:result][:session_id]
      end

      def establish_jsession_id(login_response)
        @jsession_id = login_response.http.cookies[0]
      end

      def set_session_credentials
        @header = { :SessionHeader => { :sessionId => session_id } }
      end
    end
  end
end