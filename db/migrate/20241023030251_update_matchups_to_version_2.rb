class UpdateMatchupsToVersion2 < ActiveRecord::Migration[7.2]
  def change
    update_view :matchups, version: 2, revert_to_version: 1
  end
end
