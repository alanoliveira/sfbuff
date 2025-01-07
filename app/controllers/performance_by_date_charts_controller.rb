class PerformanceByDateChartsController < ApplicationController
  include SetCurrentMatchupFilter

  def show
    return head :unprocessable_entity if CurrentMatchupFilter.home_short_id.nil?

    @matchup = CurrentMatchupFilter.matchup
  end
end
