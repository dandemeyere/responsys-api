require 'spec_helper.rb'
require 'responsys/api/client'

describe ResponsysApi::Api::Client do
	let(:connection) { double 'connection'}

	before(:all) do
		ResponsysApi.configuration.settings[:wsdl] = 'fake_wsdl'
		ResponsysApi.configuration.settings[:username] = 'fake_username'
		ResponsysApi.configuration.settings[:password] = 'fake_password'

		@credentials = {"username"=>"fake_username", "password"=>"fake_password"}
	end

	context "Authentication" do
		it "should set the credentials" do
			allow_any_instance_of(ResponsysApi::Api::Client).to receive(:login).and_return(nil)

			responsys = ResponsysApi::Api::Client.new

			expect(responsys.credentials).to eq({"username"=>"fake_username", "password"=>"fake_password"})
		end

		it "should set the session ids" do
			response = double('response')

			cookies = [ "fake_jsession_id" ]
			body = {
				:login_response => { 
					:result => {
						:session_id => "fake_session_id"
					} 
				}
			}
			allow(response).to receive(:body).and_return(body)
			allow(response).to receive(:http).and_return(double('cookies', :cookies => cookies))

			allow(Savon).to receive(:client).with({:wsdl => 'fake_wsdl', :element_form_default => :qualified}).and_return(connection) #Avoid the verification of the wsdl
			allow(connection).to receive(:run).with('login', @credentials).and_return(response) #Verification of credentials
			allow(connection).to receive(:call).with(:login, {:message => @credentials}).and_return(response) #Actual login call

			responsys = ResponsysApi::Api::Client.new

			expect(responsys.header).to eq({ "SessionHeader" => { "tns:sessionId" => "fake_session_id" } })
			expect(responsys.jsession_id).to eq('fake_jsession_id')
		end
	end
end
