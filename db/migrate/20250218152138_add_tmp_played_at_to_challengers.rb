class AddTmpPlayedAtToChallengers < ActiveRecord::Migration[8.0]
  def change
    add_column :challengers, :tmp_played_at, :datetime
  end
end
