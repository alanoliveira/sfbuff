class PlayersController < ApplicationController
  layout "with_header_footer"

  def index
    @job_id = PlayerSearchJob.perform_later(params[:q]).job_id if params.key? :q if trustable?
  end
end
