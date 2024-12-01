ActiveSupport.on_load(:active_record) do
  ActiveRecord::Type.register(:buckler_league_point, BucklerTypes::LeaguePoint)
  ActiveRecord::Type.register(:buckler_master_rating, BucklerTypes::MasterRating)
  ActiveRecord::Type.register(:buckler_round, BucklerTypes::Round)
  ActiveRecord::Type.register(:buckler_short_id, BucklerTypes::ShortId)
end
