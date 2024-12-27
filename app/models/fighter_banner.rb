class FighterBanner
  include ActiveModel::API
  include ActiveModel::Attributes

  class NotFound < StandardError; end

  class << self
    def find(short_id)
      BucklerGateway.fighter_banners(short_id:).first
    end

    def find!(short_id)
      find(short_id) || raise(NotFound)
    end

    def search(query)
      BucklerGateway.fighter_banners(query:).tap do
        _1 << find(query)
      rescue ArgumentError
      end
    end
  end

  attribute :short_id, :buckler_short_id
  attribute :name
  attribute :main_character, :buckler_character
  attribute :master_rating, :buckler_master_rating
  attribute :league_point, :buckler_league_point
  attribute :home_id, :buckler_home_id
  attribute :last_play_at, :datetime
end
