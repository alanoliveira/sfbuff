module Buckler
  class Railtie < ::Rails::Railtie
    ActiveSupport.on_load(:active_record) do
      ActiveRecord::Type.register(:buckler_league_point, RailsTypes::LeaguePoint)
      ActiveRecord::Type.register(:buckler_master_rating, RailsTypes::MasterRating)
      ActiveRecord::Type.register(:buckler_round, RailsTypes::Round)
    end
  end
end
