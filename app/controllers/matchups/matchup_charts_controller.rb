class Matchups::MatchupChartsController < ApplicationController
  include SetMatchups

  def show
    @matchup_chart = @matchups.matchup_chart
  end
end
