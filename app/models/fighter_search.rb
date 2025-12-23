class FighterSearch < ApplicationRecord
  enum :status, %w[ created processing success failure ], default: "created"
  attribute :result, :fighter_banner, json_array: true
  alias_attribute :fighter_banners, :result

  validates :query, length: { minimum: 4 }
  normalizes :query, with: ->(query) { query.strip.downcase }

  def finished?
    success? || failure?
  end

  def process
    return unless start_processing

    self[:result] = fetch_fighter_banners
    success!
  rescue => error
    self[:error] = error.class.name
    failure!
    raise
  end

  def process_later
    ProcessJob.perform_later(self)
  end

  private

  def start_processing
    created? && with_lock { processing! if created? }
  end

  def fetch_fighter_banners
    if query.match? Patterns::SHORT_ID_REGEXP
      BucklerApiGateway.search_fighter_banners(short_id: query) +
        BucklerApiGateway.search_fighter_banners(fighter_id: query)
    else
      BucklerApiGateway.search_fighter_banners(fighter_id: query)
    end
  end
end
