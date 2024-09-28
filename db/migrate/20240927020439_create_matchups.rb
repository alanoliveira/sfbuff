class CreateMatchups < ActiveRecord::Migration[7.2]
  def change
    create_view :matchups
  end
end
