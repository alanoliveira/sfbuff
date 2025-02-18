class RenameAndAddIndexToChallengersTmpPlayedAtColumn < ActiveRecord::Migration[8.0]
  def change
    rename_column :challengers, :tmp_played_at, :played_at
    change_column_comment :challengers, :played_at, from: nil, to: 'Unnormalized duplication of battles.played_at used to indexing'
    change_column_null :challengers, :played_at, false
    add_index :challengers, [ :fighter_id, :played_at ], order: { played_at: :desc }
  end
end
