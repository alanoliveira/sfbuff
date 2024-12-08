module SetCurrentMatchupFilter
  extend ActiveSupport::Concern

  included do
    before_action :set_current_matchup_filter
  end

  private

  def set_current_matchup_filter
    CurrentMatchupFilter.battle_type = params[:battle_type]
    CurrentMatchupFilter.played_from = params[:played_from]
    CurrentMatchupFilter.played_to = params[:played_to]
    CurrentMatchupFilter.home_short_id = params[:home_short_id]
    CurrentMatchupFilter.home_character = params[:home_character]
    CurrentMatchupFilter.home_control_type = params[:home_control_type]
    CurrentMatchupFilter.away_short_id = params[:away_short_id]
    CurrentMatchupFilter.away_character = params[:away_character]
    CurrentMatchupFilter.away_control_type = params[:away_control_type]
  end
end
