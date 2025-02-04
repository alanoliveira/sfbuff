class Fighters::MatchesController < ApplicationController
  include FighterScoped
  include Pagination
  include DefaultPlayedAtRange

  layout "fighters"

  def show
    @matchup = Matchup.new(matchup_parameters)

    @pagy, @challengers = @matchup
      .home_challengers
      .order(played_at: "desc")
      .includes(:battle, :opponent)
      .then { pagy(it) }
  end

  private

  def matchup_parameters
    params.permit(
      :home_character, :home_input_type,
      :away_character, :away_input_type,
      :battle_type, :played_from, :played_to
    ).merge(home_fighter_id: params[:fighter_id])
  end
end
