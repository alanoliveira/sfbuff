module Buckler
  module Api
    class NextApi
      def initialize(connection:)
        @connection = connection.tap do |conf|
          conf.response :json
        end
      end

      def fighterslist(short_id: nil, fighter_id: nil)
        params = { short_id:, fighter_id: }.compact
        raise ArgumentError if params.count != 1

        get("fighterslist/search/result.json", params)
          .fetch("fighter_banner_list")
      end

      def battlelog(short_id, page)
        get("profile/#{short_id}/battlelog.json", { page: })
          .fetch("replay_list")
      end

      private

      def get(path, params)
        @connection.get(path, params).body.fetch("pageProps")
      end
    end
  end
end
