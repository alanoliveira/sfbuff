class CreateMatches < ActiveRecord::Migration[8.1]
  def change
    create_view :matches
  end
end
