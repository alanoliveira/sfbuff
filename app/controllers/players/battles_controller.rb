class Players::BattlesController < Players::BaseController
  before_action :set_default_params, :set_battles_filter_form

  def show
    @matchups = @battles_filter_form
      .submit
      .includes(battle: :challengers)
      .ordered.reverse_order
      .page(params[:page])
  end

  def rivals
    @matchups = @battles_filter_form
      .submit
      .group(away_challenger: [ :short_id, :character, :control_type ])
      .select(Arel.sql("ANY_VALUE(away_challenger.name)").as("name"), away_challenger: [ :short_id, :character, :control_type ])
      .limit(8)
  end

  private

  def set_battles_filter_form
    @battles_filter_form = Players::BattlesFilterForm.new.fill(params)
  end

  def set_default_params
    params.compact_blank!.with_defaults!(
      "played_from" => 7.days.ago.to_date,
      "played_to" => Time.zone.now.to_date,
      "character" => @player.main_character
    )
  end
end
