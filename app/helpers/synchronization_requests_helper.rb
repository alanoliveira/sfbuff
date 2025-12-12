module SynchronizationRequestsHelper
  def synchronization_request_form(fighter, **)
    auto_submit_form_with url: fighter_synchronization_path(fighter), **
  end

  def synchronization_turbo_frame_tag(&)
    turbo_frame_tag "fighter_synchronization", &
  end
end
