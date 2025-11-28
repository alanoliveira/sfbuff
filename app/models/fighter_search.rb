class FighterSearch < ApplicationRecord
  class_attribute :refresh_interval, instance_writer: false, default: 10.minutes

  validates :query, length: { minimum: 4 }
  normalizes :query, with: ->(query) { query.strip.downcase }

  def outdated?
    performed_at.nil? || performed_at.before?(refresh_interval.ago)
  end

  def refresh!(force: false)
    return false unless outdated? && !force

    result = BucklerApiGateway.search_fighter_banners(fighter_id: query)
    if query.match? Patterns::SHORT_ID_REGEXP
      result = BucklerApiGateway.search_fighter_banners(short_id: query) + result
    end

    update(result:, performed_at: Time.zone.now)
  end
end
