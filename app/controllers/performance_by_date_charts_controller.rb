class PerformanceByDateChartsController < ApplicationController
  include SetCurrentMatchupFilter

  def show
    @matchup = CurrentMatchupFilter.matchup
  end
end
