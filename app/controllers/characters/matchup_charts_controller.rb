class Characters::MatchupChartsController < ApplicationController
  include CharacterScope
  include SetCurrentMatchupFilter

  def show
    ahoy.track("characters/matchup_charts#show", CurrentMatchupFilter.attributes.compact_blank)

    @job = MatchupChartJob.perform_later(CurrentMatchupFilter.attributes)
  end
end
