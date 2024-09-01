class Buckler::Api::FighterBanner
  attr_reader :client

  def initialize(client:)
    @client = client
  end

  def search_fighter_banner(term:)
    fighter_banner_list(fighter_id: term)
  end

  def player_fighter_banner(short_id:)
    fighter_banner_list(short_id:).first
  end

  private

  def fighter_banner_list(params)
    action_path = "fighterslist/search/result.json"
    client.request(action_path:, params:).fetch("fighter_banner_list")
  end
end
