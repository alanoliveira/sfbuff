module SynchronizationRequestsHelper
  def synchronization_request_form(fighter, **)
    auto_submit_form_with url: fighter_synchronization_path(fighter), **
  end
end
