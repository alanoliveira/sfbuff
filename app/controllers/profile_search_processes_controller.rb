class ProfileSearchProcessesController < ApplicationController
  rate_limit to: 10, within: 1.minutes, only: :create, with: -> { too_many_requests }

  def create
    ahoy.track("ProfileSearchProcessesController#create", profile_search_process_params.to_h)
    @profile_search_process = ProfileSearchProcess.new(profile_search_process_params)
    head :unprocessable_content unless @profile_search_process.save
  end

  private

  def profile_search_process_params
    params.expect(profile_search_process: [ :query ])
  end
end
