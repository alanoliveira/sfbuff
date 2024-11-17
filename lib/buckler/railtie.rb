module Buckler
  class Railtie < ::Rails::Railtie
    ActiveSupport.on_load(:active_record) do
      ActiveRecord::Type.register(:buckler_short_id, Rails::ShortIdType)
      ActiveRecord::Type.register(:buckler_league_point, Rails::LeaguePointType)
      ActiveRecord::Type.register(:buckler_master_rating, Rails::MasterRatingType)
      ActiveRecord::Type.register(:buckler_round, Rails::RoundType)
    end
  end
end
