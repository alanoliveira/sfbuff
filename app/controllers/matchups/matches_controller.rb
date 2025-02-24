class Matchups::MatchesController < ApplicationController
  include SetMatchup
  include Pagination

  def show
    @pagy, @challengers = @matchup
      .home_challengers
      .order(matchup_index: { played_at: :desc })
      .includes(:battle, :opponent)
      .then { pagy(it) }
  end

  private

  def matchup_parameters
    params.permit(
      :home_fighter_id, :home_character, :home_input_type,
      :away_fighter_id, :away_character, :away_input_type,
      :battle_type, :played_from, :played_to).compact_blank
  end
end
