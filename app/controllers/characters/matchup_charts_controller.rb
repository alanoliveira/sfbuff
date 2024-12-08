class Characters::MatchupChartsController < ApplicationController
  include CharacterScope
  include SetCurrentMatchupFilter

  def show
    @job = MatchupChartJob.perform_later(CurrentMatchupFilter.attributes)
  end
end
