class BucklerApiGateway
  attr_accessor :buckler_api_client

  class << self
    delegate_missing_to :default_instance

    def default_instance
      build_id = ENV["BUCKLER_BUILD_ID"]
      auth_cookie = ENV["BUCKLER_AUTH_COOKIE"]
      @default_instance ||= new(BucklerApiClient.new(build_id:, auth_cookie:))
    end
  end

  def initialize(buckler_api_client)
    @buckler_api_client = buckler_api_client
  end

  def search_fighter_banners(fighter_id: nil, short_id: nil)
    result = buckler_api_client.fighterslist(fighter_id:, short_id:)
    result["pageProps"]["fighter_banner_list"].map do
      Mappers::FighterBanner.new it
    end
  end

  def fetch_fighter_replays(short_id)
    buckler_api_client.battlelog(short_id).flat_map do |result|
      result["pageProps"]["replay_list"].map do
        Mappers::Replay.new it
      end
    end
  end

  def fetch_fighter_play_profile(fighter_id)
    result = buckler_api_client.play_profile(fighter_id)
    Mappers::PlayProfile.new result["pageProps"]
  end
end
