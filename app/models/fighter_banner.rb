class FighterBanner
  include ActiveModel::API
  include ActiveModel::Attributes

  class << self
    def find(short_id)
      ShortId.new(short_id) rescue return nil

      search_map(short_id:).first
    end

    def search(query)
      [ find(query) ].compact | search_map(fighter_id: query)
    end

    private

    def search_map(**)
      BucklerApi.fighterslist(**).map do |raw_data|
        Parsers::FighterBannerParser.parse(raw_data:)
      end
    end
  end

  attribute :short_id, :buckler_short_id
  attribute :name
  attribute :main_character, :buckler_character
  attribute :master_rating, :buckler_master_rating
  attribute :league_point, :buckler_league_point
  attribute :home_id, :buckler_home_id
end
