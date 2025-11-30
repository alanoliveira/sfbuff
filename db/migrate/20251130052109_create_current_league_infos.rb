class CreateCurrentLeagueInfos < ActiveRecord::Migration[8.1]
  def change
    create_table :current_league_infos do |t|
      t.integer :character_id, null: false
      t.integer :mr
      t.integer :lp
      t.belongs_to :fighter, null: false, foreign_key: true

      t.timestamps

      t.index [ :fighter_id, :character_id ], unique: true
    end
  end
end
