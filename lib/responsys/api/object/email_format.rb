module Responsys
  module Api
    module Object
      class EmailFormat
        include Responsys::Api::Object
        attr_accessor :email_format_string
        AVAILABLE_EMAIL_FORMAT = %w(TEXT_FORMAT HTML_FORMAT NO_FORMAT MULTIPART_FORMAT)

        def initialize(email_format = "NO_FORMAT")
          if AVAILABLE_EMAIL_FORMAT.include? email_format
            @email_format_string = email_format
          else
            raise ParameterException, I18n.t("api.object.email_format.incorrect")
          end
        end

        def to_api
          @email_format_string
        end
      end
    end
  end
end
