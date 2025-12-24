class AddSynchronizedAtToFighters < ActiveRecord::Migration[8.1]
  def change
    add_column :fighters, :synchronized_at, :datetime
  end
end
