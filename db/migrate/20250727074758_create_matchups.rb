class CreateMatchups < ActiveRecord::Migration[8.0]
  def change
    create_view :matchups
  end
end
