require "spec_helper.rb"
require "responsys/api/client"
require "singleton"

describe Responsys::Api::Client do

  context "Authentication" do
    let(:savon_client) { double("savon client") }

    before(:context) do
      @credentials = { username: "your_responsys_username", password: "your_responsys_password" }
    end

    after(:context) do
      Singleton.__init__(Responsys::Api::Client)
    end

    it "should set the credentials" do
      allow_any_instance_of(Responsys::Api::Client).to receive(:login).and_return(nil)

      responsys = Responsys::Api::Client.instance

      expect(responsys.credentials).to eq({ username: "your_responsys_username", password: "your_responsys_password" })
    end

    context "login" do
      before(:example) do
        response = double("response")

        cookies = %w(fake_jsession_id)
        body = {
          login_response: {
            result: {
              session_id: "fake_session_id"
            }
          }
        }

        allow(response).to receive(:body).and_return(body)
        allow(response).to receive(:http).and_return(double("cookies", cookies: cookies))

        allow(Savon).to receive(:client).with({ wsdl: "https://wsxxxx.responsys.net/webservices/wsdl/ResponsysWS_Level1.wsdl", element_form_default: :qualified }).and_return(savon_client) #Avoid the verification of the wsdl
        allow_any_instance_of(Responsys::Api::Client).to receive(:run).with("login", @credentials).and_return(response) #Verification of credentials
        allow(savon_client).to receive(:call).with(:login, @credentials ).and_return(response) #Actual login call

        Singleton.__init__(Responsys::Api::Client)
      end

      it "should set the session ids" do
        instance = Responsys::Api::Client.instance #Get it

        expect(instance.header).to eq({ SessionHeader: { sessionId: "fake_session_id" } }) #Test the ids are right
        expect(instance.jsession_id).to eq("fake_jsession_id")
      end
    end

    context "logout" do
      before(:example) do
        allow(Savon).to receive(:client).with({ wsdl: "https://wsxxxx.responsys.net/webservices/wsdl/ResponsysWS_Level1.wsdl", element_form_default: :qualified }).and_return(savon_client) #Avoid the verification of the wsdl
        allow_any_instance_of(Responsys::Api::Client).to receive(:login).and_return(nil) #Avoid credentials checking

        Singleton.__init__(Responsys::Api::Client)
      end

      it "should logout" do
        instance = Responsys::Api::Client.instance #Get it

        allow(Responsys::Helper).to receive(:format_response_hash).with(any_args) #We dont want to parse the response
        expect(savon_client).to receive(:call).with(:logout, anything) #Check the call is actually being done

        instance.logout
      end
    end
  end
end
