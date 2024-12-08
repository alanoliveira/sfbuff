class Players::RankedHistoriesController < ApplicationController
  include PlayerScope
  include SetCurrentMatchupFilter

  def show
    @ranked_history = RankedHistory.new(
      CurrentMatchupFilter.home_short_id,
      CurrentMatchupFilter.home_character,
      date_range: CurrentMatchupFilter.played_at_range)
  end

  def params
    super.with_defaults(
      home_short_id: @player&.short_id,
      home_character: @player&.main_character,
    )
  end
end
