class RenameCurrentLeagueInfosTableToCurrentLeagues < ActiveRecord::Migration[8.1]
  def change
    rename_table :current_league_infos, :current_leagues
  end
end
