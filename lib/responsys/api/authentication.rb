module Responsys
  module Api
    module Authentication
      def login
        logout if logged_in?

        response = run(:login, credentials)
        establish_session_id(response)
        establish_jsession_id(response)
        set_session_credentials
      end

      def logout
        return unless logged_in?

        run_with_credentials(:logout, nil)
        destroy_session_objects
      end

      def logged_in?
        !(session_id.nil? || jsession_id.nil? || header.nil?)
      end

      private

      def establish_session_id(login_response)
        @session_id = login_response.body[:login_response][:result][:session_id]
      end

      def establish_jsession_id(login_response)
        @jsession_id = login_response.http.cookies[0]
      end

      def set_session_credentials
        @header = { SessionHeader: { sessionId: session_id } }
      end

      def destroy_session_objects
        @session_id = nil
        @jsession_id = nil
        @header = nil
      end
    end
  end
end