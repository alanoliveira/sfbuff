class RecreateRankedStepView < ActiveRecord::Migration[8.0]
  def change
    create_view :ranked_steps
  end
end
