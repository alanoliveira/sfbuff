class FighterSearchProcessesController < ApplicationController
  rate_limit to: 10, within: 1.minutes, only: :create, with: -> { too_many_requests }

  def create
    ahoy.track("FighterSearchesController#create", fighter_search_process_params.to_h)
    @fighter_search_process = FighterSearchProcess.new(fighter_search_process_params)
    head :unprocessable_content unless @fighter_search_process.save
  end

  private

  def fighter_search_process_params
    params.expect(fighter_search_process: [ :query ])
  end
end
