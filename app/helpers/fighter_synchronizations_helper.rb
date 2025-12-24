module FighterSynchronizationsHelper
  def fighter_synchronization_turbo_frame_tag(&blk)
    turbo_frame_tag "fighter_synchronization", &blk
  end

  def fighter_synchronization_request_form(fighter, **)
    auto_submit_form_with url: fighter_synchronization_path(fighter), **
  end
end
