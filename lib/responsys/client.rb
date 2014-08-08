require 'version'
require 'responsys_helper'
require 'savon'

module ResponsysApi
  class Client
    ###### Initialization/Session mgmt ######
    def initialize(wsdl=nil, username=nil, password=nil)
      #Get the settings
      @wsdl = wsdl || ResponsysApi.wsdl || raise(ArgumentError, "You must provide a WSDL or call ResponsysApi.settings() first")
      @username = username || ResponsysApi.username || raise(ArgumentError, "You must provide a username or call ResponsysApi.settings() first")
      @password = password || ResponsysApi.password || raise(ArgumentError, "You must provide a password or call ResponsysApi.settings() first")

      #Connection to the API with the credentials
      @client = connect
    end

    #Set up the @client object used to call the api
    def connect
      sessionIds = login
      @client = Savon.client(
        wsdl: @wsdl,
        soap_header: { "sessionHeader" => { "sessionId" => sessionIds["sessionId"] } },
        headers: { "Cookie" => "JSESSIONID=#{sessionIds['jSessionId']}" },
        element_form_default: :qualified
      )
    end

    #Return the session ids required to identify the client
    def login
      temp_connection = Savon.client(wsdl: @wsdl,element_form_default: :qualified)

      response = temp_connection.call(:login, message: { "username"=>@username,"password"=>@password })

      result = ResponsysApi::Helper::get_result(response, 'login')

      #Keep the Soap SessionId which is to be used in each soap header requests
      sessionId = result[:session_id]

      #Keep the JSESSIONID which is to be inserted in each HTTP header of soap requests
      jSessionId = response.http.headers["set-cookie"][0].split(';')[0].partition('=')[2]

      {"sessionId" => sessionId, "jSessionId" => jSessionId}
    end

    def logout
      @client.call(:logout)
      @client=nil
    end

    def connected?
      !@client.nil?
    end
    ###### End Initialization/Session mgmt ######

    ###### Folders ######
    def listFolders
      response = @client.call(:list_folders)

      ResponsysApi::Helper::get_result(response, 'list_folders')
    end
    ###### End Folders ######
  end
end
