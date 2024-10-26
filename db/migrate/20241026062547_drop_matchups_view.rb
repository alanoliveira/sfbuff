class DropMatchupsView < ActiveRecord::Migration[7.2]
  def change
    execute "DROP VIEW IF EXISTS matchups"
  end
end
