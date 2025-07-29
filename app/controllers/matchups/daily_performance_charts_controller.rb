class Matchups::DailyPerformanceChartsController < ApplicationController
  include SetMatchups

  def show
    @daily_performance_data = @matchups.scoreboard_by_day
  end
end
