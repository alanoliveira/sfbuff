module SetMatchups
  extend ActiveSupport::Concern

  included do
    include WithDefaultPlayedAtRange
    before_action :set_matchups
  end

  private

  def set_matchups
    from_date = Date.parse(params[:played_from]) rescue Date.today
    to_date = Date.parse(params[:played_to]) rescue Date.today

    @matchups = Matchup
      .where(matchups_search_params.compact_blank)
      .where(played_at: from_date.beginning_of_day..to_date.end_of_day)
  end

  def matchups_search_params
    params.permit(
      :home_fighter_id, :home_character_id, :home_input_type_id,
      :away_fighter_id, :away_character_id, :away_input_type_id,
      :battle_type_id)
  end
end
