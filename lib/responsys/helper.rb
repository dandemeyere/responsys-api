class ResponsysApi
  module Helper
    def self.format_response(response, action)
      response.body[("#{action}_response").to_sym][:result]
    end
  end
end
