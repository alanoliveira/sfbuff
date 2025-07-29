class DropRankedStepsView < ActiveRecord::Migration[8.0]
  def change
    drop_view :ranked_steps
  end
end
