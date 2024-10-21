require_relative "../../config/environment"

loop do
  battles = Battle.preload(:challengers).find_by_sql(<<-SQL)
    select battles.* from battles
    inner join challengers p1 on p1.battle_id = battles.id and p1.side = 1
    inner join challengers p2 on p2.battle_id = battles.id and p2.side = 2
    where battles.battle_type = #{Buckler::Enums::BATTLE_TYPES["ranked"]}
    and p1.master_rating > 0
    and p2.master_rating > 0
    and p1.ranked_variation is null and p2.ranked_variation is null
    limit 1000
  SQL

  break if battles.empty?

  battles.flat_map(&:challengers).each do |challenger|
    challenger.update({})
  end
end
