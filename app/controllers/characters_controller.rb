class CharactersController < ApplicationController
  include DefaultPlayedAtRange
  include MatchupsActions

  layout "with_header_footer", only: :index

  def index
  end

  def matchup_chart
    filter_params = params.permit(:character, :control_type, :played_from,
      :played_to, :battle_type, :mr_from, :mr_to, :vs_mr_from, :vs_mr_to)
    @job_id = MatchupChartJob.perform_later(filter_params.to_h).job_id if trustable?
  end
end
