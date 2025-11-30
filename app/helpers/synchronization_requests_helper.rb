module SynchronizationRequestsHelper
  def synchronization_request_form(fighter, **)
    auto_submit_form_with url: synchronize_fighter_path(fighter), **
  end
end
