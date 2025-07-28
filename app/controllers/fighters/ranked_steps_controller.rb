class Fighters::RankedStepsController < ApplicationController
  include FighterScoped
  include WithDefaultPlayedAtRange
  before_action :set_default_character_id

  layout :fighter_layout

  def show
    from_date = Date.parse(params[:played_from]) rescue Date.today
    to_date = Date.parse(params[:played_to]) rescue Date.today

    @ranked_steps = RankedStep
      .not_calibrating
      .where(
        fighter_id: params[:fighter_id],
        character_id: params[:home_character_id],
        played_at: from_date.beginning_of_day..to_date.end_of_day)
  end

  private

  def set_default_character_id
    return if params[:home_character_id].present?
    params[:home_character_id] = @fighter.profile.main_character_id
  end
end
