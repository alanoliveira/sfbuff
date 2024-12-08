module SetCurrentMatchupFilter
  ALLOWED_ATTRIBUTES = %i[
    battle_type played_from played_to
    home_short_id home_character home_control_type home_mr_from home_mr_to home_lp_from home_lp_to
    away_short_id away_character away_control_type away_mr_from away_mr_to away_lp_from away_lp_to]

  extend ActiveSupport::Concern

  included do
    around_action :set_current_matchup_filter
  end

  private

  def set_current_matchup_filter(&)
    CurrentMatchupFilter.set(params.with_defaults(
      played_from: (Time.zone.today-7.days).iso8601,
      played_to: Time.zone.today.iso8601
    ).permit(ALLOWED_ATTRIBUTES), &)
  end
end
