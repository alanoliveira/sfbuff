class Players::RankedHistoriesController < ApplicationController
  include Players::MatchupScope
  include PlayerScope
  include SetCurrentMatchupFilter

  def show
    @ranked_history = RankedHistory.new(
      CurrentMatchupFilter.home_short_id,
      CurrentMatchupFilter.home_character,
      date_range: CurrentMatchupFilter.played_at_range).then do |ranked_history|
        cache(ranked_history) { ranked_history.tap(&:load) }
      end
  end

  def params
    super.compact_blank.with_defaults(
      home_character: @player&.main_character.to_i,
    )
  end
end
