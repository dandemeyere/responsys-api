module ResponsysApi
  module Helper
    # Format the response of a Savon SOAP request
    # Params:
    # +response+:: object returned by a Savon request
    # +action+:: name of the action
    def self.format_response(response, action)
      response.body[("#{action}_response").to_sym][:result]
    end
  end
end
