class AddRankedVariationToChallengers < ActiveRecord::Migration[7.2]
  def change
    add_column :challengers, :ranked_variation, :json
  end
end
