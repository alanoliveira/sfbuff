module BucklerApi
  class Client
    attr_accessor :connection

    def initialize(connection)
      @connection = connection
    end

    def search_fighters(short_id: nil, fighter_id: nil)
      params = { short_id:, fighter_id: }.compact
      get("fighterslist/search/result.json", params).fetch("fighter_banner_list")
    end

    def fighter_battlelog(short_id, page)
      get("profile/#{short_id}/battlelog.json", { page: }).fetch("replay_list")
    end

    private

    def get(path, params)
      connection.get(path, **params).page_props
    end
  end
end
