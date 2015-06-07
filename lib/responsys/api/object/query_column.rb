module Responsys
  module Api
    module Object
      class QueryColumn
        include Responsys::Exceptions
        attr_accessor :query_column_string

        AVAILABLE_QUERY_COLUMN = {
          RIID: "r",
          CUSTOMER_ID: "c",
          EMAIL_ADDRESS: "e",
          MOBILE_NUMBER: "m"
        }

        def initialize(query_column)
          if AVAILABLE_QUERY_COLUMN.keys.include?(query_column.to_sym)
            @query_column_string = query_column
          else
            raise ParameterException.new("api.object.query_column.incorrect_query_column")
          end
        end

        def to_api
          @query_column_string
        end

        def to_param
          AVAILABLE_QUERY_COLUMN[query_column_string.to_sym]
        end
      end
    end
  end
end