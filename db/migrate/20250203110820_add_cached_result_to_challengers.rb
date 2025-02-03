class AddCachedResultToChallengers < ActiveRecord::Migration[8.0]
  def change
    add_column :challengers, :cached_result, :integer
  end
end
