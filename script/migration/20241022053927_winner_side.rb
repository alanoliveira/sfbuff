require_relative "../../config/environment"

ActiveRecord::Base.connection.execute(<<-SQL)
  UPDATE battles
  SET winner_side = winner.side
  FROM challengers winner
  WHERE winner.battle_id = battles.id
  AND winner.result = #{Challenger.results["win"]}
SQL
