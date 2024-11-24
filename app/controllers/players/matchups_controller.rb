class Players::MatchupsController < Players::BaseController
  include ParamsWithDefaultPlayedAtRange

  private

  def filter_params
    params.permit(:short_id, :character, :control_type, :vs_character,
      :vs_control_type, :played_from, :played_to, :battle_type)
  end
end
