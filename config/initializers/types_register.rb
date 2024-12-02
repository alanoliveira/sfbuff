ActiveSupport.on_load(:active_record) do
  ActiveRecord::Type.register(:buckler_league_point, BucklerTypes::LeaguePoint)
  ActiveRecord::Type.register(:buckler_master_rating, BucklerTypes::MasterRating)
  ActiveRecord::Type.register(:buckler_round, BucklerTypes::Round)
  ActiveRecord::Type.register(:buckler_short_id, BucklerTypes::ShortId)
  ActiveRecord::Type.register(:buckler_character, BucklerTypes::Character)
  ActiveRecord::Type.register(:buckler_control_type, BucklerTypes::ControlType)
  ActiveRecord::Type.register(:buckler_battle_type, BucklerTypes::BattleType)
  ActiveRecord::Type.register(:buckler_home_id, BucklerTypes::HomeId)

  ActiveModel::Type.register(:buckler_league_point, BucklerTypes::LeaguePoint)
  ActiveModel::Type.register(:buckler_master_rating, BucklerTypes::MasterRating)
  ActiveModel::Type.register(:buckler_round, BucklerTypes::Round)
  ActiveModel::Type.register(:buckler_short_id, BucklerTypes::ShortId)
  ActiveModel::Type.register(:buckler_character, BucklerTypes::Character)
  ActiveModel::Type.register(:buckler_control_type, BucklerTypes::ControlType)
  ActiveModel::Type.register(:buckler_battle_type, BucklerTypes::BattleType)
  ActiveModel::Type.register(:buckler_home_id, BucklerTypes::HomeId)
end
