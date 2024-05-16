class AddWinnerSideToBattle < ActiveRecord::Migration[7.1]
  def up
    add_column :battles, :winner_side, :integer
    Battle.all.each do |battle|
      raw = JSON.parse(battle.raw_data)
      reparsed = Parsers::BattlelogParser.parse(raw)
      battle.winner_side = reparsed.winner_side
      battle.save
    end
  end

  def down
    remove_column :battles, :winner_side
  end
end
