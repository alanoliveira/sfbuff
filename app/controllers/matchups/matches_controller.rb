class Matchups::MatchesController < ApplicationController
  include SetMatchup
  include Pagination

  def show
    @pagy, @challengers = @matchup
      .home_challengers
      .order(played_at: "desc")
      .includes(:battle, :opponent)
      .then do
        if (@matchup.played_to.to_time - @matchup.played_from.to_time) > 1.month
          pagy_countless(it)
        else
          pagy(it)
        end
      end
  end

  private

  def matchup_parameters
    params.permit(
      :home_fighter_id, :home_character, :home_input_type,
      :away_fighter_id, :away_character, :away_input_type,
      :battle_type, :played_from, :played_to).compact_blank
  end
end
