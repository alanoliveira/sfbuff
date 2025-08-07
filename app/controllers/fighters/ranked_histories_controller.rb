class Fighters::RankedHistoriesController < ApplicationController
  include FighterScoped
  include WithDefaultPlayedAtRange
  before_action :set_default_character_id

  layout :fighter_layout
  fresh_when_unsynchronized

  def show
    @ranked_history = RankedHistory.new(**ranked_history_params)
  end

  private

  def ranked_history_params
    from_date = Date.parse(params[:played_from]) rescue Time.zone.today
    to_date = Date.parse(params[:played_to]) rescue Time.zone.today
    character_id = params[:home_character_id].to_i

    {
      fighter_id: @fighter.id,
      from_date: from_date,
      to_date: to_date,
      character_id:
    }
  end

  def set_default_character_id
    return if params[:home_character_id].present?
    params[:home_character_id] = @fighter.profile.main_character_id
  end
end
