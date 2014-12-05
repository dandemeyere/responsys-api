require "spec_helper.rb"

describe Responsys::Api::Session do
  context "Authentication" do
    let(:savon_client) { double("savon client") }
    let(:credentials) { { username: CREDENTIALS["username"], password: CREDENTIALS["password"] } }

    it "should set the credentials" do
      expect(subject.credentials).to eq(credentials)
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
        allow(subject).to receive(:run).with(:login, credentials).and_return(response) #Verification of credentials
        allow(savon_client).to receive(:call).with(:login, message: credentials).and_return(response) #Actual login call
      end

      it "should set the session ids" do
        subject.login

        expect(subject.header).to eq({ SessionHeader: { sessionId: "fake_session_id" } }) #Test the ids are right
        expect(subject.jsession_id).to eq("fake_jsession_id")
      end
    end

    context "logout" do
      it "should logout" do
        allow(subject).to receive(:logged_in?).and_return(true)
        expect(subject).to receive(:run_with_credentials).with(:logout, nil) #Check the call is actually being done

        subject.logout
      end
    end
  end
end