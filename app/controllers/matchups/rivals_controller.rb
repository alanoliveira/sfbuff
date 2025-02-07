class Matchups::RivalsController < ApplicationController
  include DefaultPlayedAtRange
  include SetMatchup

  def show
    @rivals = @matchup.rivals(8)
  end

  private

  def matchup_parameters
    params.permit(
      :home_fighter_id, :home_character, :home_input_type,
      :away_fighter_id, :away_character, :away_input_type,
      :battle_type, :played_from, :played_to).compact_blank
  end
end
