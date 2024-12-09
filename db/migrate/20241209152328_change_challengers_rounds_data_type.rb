class ChangeChallengersRoundsDataType < ActiveRecord::Migration[8.0]
  def change
    change_table :challengers do |t|
      t.change :rounds, "json USING to_json(rounds)"
    end
  end
end
