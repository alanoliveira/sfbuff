class FighterSearcher
  cattr_reader :cache, default: Rails.cache

  attr_reader :query, :buckler_gateway

  def initialize(query, buckler_gateway: nil)
    @query = query.to_s
    @buckler_gateway = buckler_gateway || BucklerGateway.new
  end

  def search
    cache.fetch cache_key, expires_in: 20.minutes do
      search_by_id | search_by_name
    end.map { FighterProfile.new(it) }
  end

  def cache_key
    [ "fighter_searcher", query ]
  end

  private

  def search_by_name
    buckler_gateway.search_fighter_profile(name: query)
  end

  def search_by_id
    return [] unless query.match? Fighter::FIGHTER_ID_REGEXP
    buckler_gateway.search_fighter_profile(fighter_id: query)
  end
end
