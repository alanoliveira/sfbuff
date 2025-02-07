class FighterSearch
  include ActiveModel::Model
  include ActiveModel::Attributes
  include Turbo::Broadcastable

  attribute :id, default: -> { SecureRandom.uuid }
  attribute :query
  attribute :result

  validates :query, length: { minimum: 4 }

  def query=(val)
    super(val.strip.downcase)
  end

  def search_now
    assign_attributes(result: fetch_results)
    ensure broadcast_render
  end

  def search_later(...)
    FighterSearch::SearchJob.set(...).perform_later(self)
  end

  def to_key
    [ id ]
  end

  def to_param
    id
  end

  def cached?
    Rails.cache.read(search_cache_key).try do |cached|
      assign_attributes(result: cached)
    end
  end

  private

  def search_cache_key
    [ model_name.cache_key, query ]
  end

  def fetch_results
    return [] unless valid?

    id_result = BucklerGateway.find_fighter_profile(query) if Fighter::FIGHTER_ID_REGEXP.match? query.to_s
    Rails.cache.fetch search_cache_key, expires: 10.minutes do
      Array(id_result) | BucklerGateway.search_fighter_profile(query)
    end
  end
end
