class AddResultToChallengers < ActiveRecord::Migration[7.2]
  def change
    add_column :challengers, :result, :integer
  end
end
