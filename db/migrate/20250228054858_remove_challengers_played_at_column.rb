class RemoveChallengersPlayedAtColumn < ActiveRecord::Migration[8.0]
  def change
    remove_column :challengers, :played_at
  end
end
