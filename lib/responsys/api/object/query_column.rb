module Responsys
  module Api
    module Object
      class QueryColumn
        include Responsys::Exceptions
        attr_accessor :query_column_string
        AVAILABLE_QUERY_COLUMN = %w(RIID CUSTOMER_ID EMAIL_ADDRESS MOBILE_NUMBER)

        def initialize(query_column)
          if AVAILABLE_QUERY_COLUMN.include? query_column
            self.query_column_string = query_column
          else
            raise ParameterException, I18n.t("api.object.query_column.incorrect")
          end
        end

        def to_api
          query_column_string
        end
      end
    end
  end
end