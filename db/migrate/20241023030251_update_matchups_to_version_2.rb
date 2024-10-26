class UpdateMatchupsToVersion2 < ActiveRecord::Migration[7.2]
  def change
    # commented out due to removal of scenic gem
    # update_view :matchups, version: 2, revert_to_version: 1
  end
end
