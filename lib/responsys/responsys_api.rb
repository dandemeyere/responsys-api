require 'savon'

class ResponsysApi
  attr_accessor :credentials, :client, :session_id, :jsession_id, :header

  def initialize
    settings = ResponsysApi.configuration.settings
    @credentials = {
      "tns:username" => settings[:username],
      "tns:password" => settings[:password]
    }
    @client = SavonApi.new(settings[:wsdl])
    login
  end

  def login
    response = client.run("login", credentials)
    establish_session_id(response)
    establish_jsession_id(response)
    set_session_credentials
  end

  def api_method(action, message = nil)
    response = client.run_with_credentials(action, message, jsession_id, header)
    ResponsysApi::Helper.format_response(response, action)
  end

  private

  def establish_session_id(login_response)
    @session_id = login_response.body[:login_response][:result][:session_id]
  end

  def establish_jsession_id(login_response)
    @jsession_id = login_response.http.cookies[0]
  end

  def set_session_credentials
    @header = { "SessionHeader" => { "tns:sessionId" => session_id } }
  end
end
