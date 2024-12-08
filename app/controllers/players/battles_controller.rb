class Players::BattlesController < ApplicationController
  include PlayerScope
  include SetCurrentMatchupFilter

  def show
    @matchup = CurrentMatchupFilter.matchup
    @pagy, @page_matchups = pagy(@matchup.order(played_at: :desc))
  end

  def params
    super.with_defaults(
      home_short_id: @player&.short_id&.to_i,
    )
  end
end
