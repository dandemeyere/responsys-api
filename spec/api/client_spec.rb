require "spec_helper.rb"

describe Responsys::Api::Client do

  describe "Authentication methods" do
    it "should refuse the access to api_method for logout" do
        expect{ subject.api_method(:logout) }.to raise_error("Please use the dedicated logout method")
    end

    it "should refuse the access to api_method for login" do
      expect{ subject.api_method(:login) }.to raise_error("Please use the dedicated login method")
    end
  end

end