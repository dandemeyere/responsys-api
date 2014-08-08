require 'savon'

class ResponsysApi
  attr_accessor :client, :session_id, :jsession_id, :header

  def initialize(username, password, wsdl)
    @username = username
    @password = password
    @wsdl = wsdl
    @client = SavonApi.new(wsdl)
    login
  end

  def login
    response = client.run("login", login_credentials)
    establish_session_id(response)
    establish_jsession_id(response)
    set_session_credentials
    response
  end

  def api_method(method_name, message)
    client.run_with_credentials(method_name, message, jsession_id, header)
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
