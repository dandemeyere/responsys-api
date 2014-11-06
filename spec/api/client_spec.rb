require "spec_helper.rb"
require "responsys/api/client"
require "singleton"

describe Responsys::Api::Client do

  context "Authentication" do
    subject { Responsys::Api::Client.instance }
    let(:savon_client) { double("savon client") }

    before(:context) do
      @credentials = { username: CREDENTIALS["username"], password: CREDENTIALS["password"] }
    end

    after(:context) do
      Singleton.__init__(Responsys::Api::Client)
    end

    it "should set the credentials" do
      allow_any_instance_of(Responsys::Api::Client).to receive(:login).and_return(nil)

      responsys = Responsys::Api::Client.instance

      expect(responsys.credentials).to eq({ username: CREDENTIALS["username"], password: CREDENTIALS["password"] })
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

        allow(Savon).to receive(:client).with({ wsdl: CREDENTIALS["wsdl"], element_form_default: :qualified, ssl_version: :TLSv1}).and_return(savon_client) #Avoid the verification of the wsdl
        allow_any_instance_of(Responsys::Api::Client).to receive(:run).with("login", @credentials).and_return(response) #Verification of credentials
        allow(savon_client).to receive(:call).with(:login, @credentials ).and_return(response) #Actual login call

        Singleton.__init__(Responsys::Api::Client)
      end

      it "should set the session ids" do
        subject.login

        expect(subject.header).to eq({ SessionHeader: { sessionId: "fake_session_id" } }) #Test the ids are right
        expect(subject.jsession_id).to eq("fake_jsession_id")
      end
    end

    context "logout" do
      subject { Responsys::Api::Client.instance }

      it "should logout" do
        expect(subject).to receive(:run_with_credentials).with(:logout, anything, anything, anything) #Check the call is actually being done

        subject.logout
      end
    end
  end
end
