class MatchupIndex < ApplicationRecord
  class << self
    def index(challenger)
      create!(
        battle_id: challenger.battle.id,
        played_at: challenger.battle.played_at,
        battle_type: challenger.battle.battle_type_for_database,

        home_fighter_id: challenger.fighter_id,
        home_challenger_id: challenger.id,
        home_character_id: challenger.character_id,
        home_input_type_id: challenger.input_type_id,

        away_fighter_id: challenger.opponent.fighter_id,
        away_challenger_id: challenger.opponent.id,
        away_character_id: challenger.opponent.character_id,
        away_input_type_id: challenger.opponent.input_type_id,
      )
    end

    def reindex!
      with_connection do |conn|
        conn.execute("BEGIN")
        conn.execute("LOCK TABLE #{table_name} IN EXCLUSIVE MODE")
        conn.execute("TRUNCATE TABLE #{table_name}")
        conn.execute(<<~SQL)
          INSERT INTO #{table_name} (battle_id, played_at, battle_type,
             home_challenger_id, home_fighter_id, home_character_id, home_input_type_id,
             away_challenger_id, away_fighter_id, away_character_id, away_input_type_id)
          SELECT battles.id, battles.played_at, battles.battle_type,
            home.id, home.fighter_id, home.character_id, home.input_type_id,
            away.id, away.fighter_id, away.character_id, away.input_type_id
          FROM battles
          INNER JOIN challengers home ON battles.id = home.battle_id
          INNER JOIN challengers away ON battles.id = away.battle_id
          WHERE home.id != away.id
        SQL
        conn.execute("COMMIT")
      end
    end
  end
end
