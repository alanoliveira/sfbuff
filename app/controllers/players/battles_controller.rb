class Players::BattlesController < Players::BaseController
  before_action :set_filter_form

  def show
    @matchups = @player.matchups
      .merge(@filter_form.submit)
      .includes(battle: :challengers)
      .ordered.reverse_order
      .page(params[:page])
    @score = cache([ @filter_form, "score" ]) { @matchups.except(:order, :offset, :limit).score }
    @total_pages = cache([ @filter_form, "total_pages" ]) { @matchups.total_pages }
  end

  def rivals
    @matchups = @player.matchups
      .merge(@filter_form.submit)
      .group(away_challenger: [ :short_id, :character, :control_type ])
      .select(Arel.sql("ANY_VALUE(away_challenger.name)").as("name"), away_challenger: [ :short_id, :character, :control_type ])
      .limit(8)
  end

  private

  def set_filter_form
    @filter_form = Players::MatchupsFilterForm.new(filter_form_params)
  end

  def filter_form_params
    params
      .compact_blank
      .with_defaults(played_from:  7.days.ago.to_date,
        played_to: Time.zone.now.to_date, character: @player.main_character)
      .permit(:character, :control_type, :vs_character, :vs_control_type,
        :played_from, :played_to, :battle_type)
  end
end
