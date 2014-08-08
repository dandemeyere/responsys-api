require 'spec_helper.rb'

describe ResponsysApi do
  context '#initialize' do
    it "should initialize with the right variables" do
      ResponsysApi.configure do |config|
        config.settings = {
          username: 'api@demo003',
          password: '$Pimpmycloset01',
          wsdl: 'https://ws2.responsys.net/webservices/wsdl/ResponsysWS_Level1.wsdl'
        }
      end
      expect(ResponsysApi.new.class).to eql ResponsysApi
    end
  end
end
