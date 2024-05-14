class AddPlayingCharacterToChallanger < ActiveRecord::Migration[7.1]
  def up
    add_column :challangers, :playing_character, :integer
    update_affected_battles
  end

  def down
    remove_column :challangers, :playing_character
  end

  def update_affected_battles
    Battle.all.each do |battle|
      raw = JSON.parse(battle.raw_data)
      is_rand = raw.dig('player1_info', 'character_id') == 254 ||
                raw.dig('player2_info', 'character_id') == 254
      next unless is_rand
      Battle.transaction do
        battle.destroy
        Parsers::BattlelogParser.parse(raw).save!
      end
    end
  end
end
