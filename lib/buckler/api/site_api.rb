module Buckler
  module Api
    class SiteApi
      def initialize(connection:)
        @connection = connection.tap do |conf|
          conf.response :raise_error
        end
      end

      def next_data
        response = @connection.get("/6/buckler")
        Parser::NextDataParser.parse(response.body)
      end
    end
  end
end
