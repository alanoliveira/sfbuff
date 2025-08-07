class CreateCharacterLeagueInfos < ActiveRecord::Migration[8.0]
  def change
    create_table :character_league_infos, primary_key: [ :fighter_id, :character_id ] do |t|
      t.bigint :fighter_id, null: false
      t.integer :character_id, null: false
      t.integer :mr
      t.integer :lp

      t.timestamps
    end
  end
end
