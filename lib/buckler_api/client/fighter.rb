module BucklerApi
  class Client::Fighter
    attr_accessor :client

    def initialize(client)
      @client = client
    end

    def search(short_id: nil, fighter_id: nil)
      params = { short_id:, fighter_id: }.compact
      client.get("fighterslist/search/result.json", params).fetch("fighter_banner_list")
    end

    def battlelog(short_id, page)
      client.get("profile/#{short_id}/battlelog.json", { page: }).fetch("replay_list")
    end

    def play_data(short_id)
      client.get("profile/#{short_id}/play.json")
    end
  end
end
