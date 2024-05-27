class AddMrVariationToChallengers < ActiveRecord::Migration[7.1]
  def up
    add_column :challengers, :mr_variation, :integer
  end

  def down
    remove_column :challengers, :mr_variation
  end
end
