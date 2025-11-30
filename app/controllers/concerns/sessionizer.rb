module Sessionizer
  extend ActiveSupport::Concern

  included do
    before_action :resume_or_start_new_session, unless: :user_is_a_bot?
  end

  private

  def user_is_a_bot?
    DeviceDetector.new(request.user_agent).bot?
  end

  def resume_or_start_new_session
    resume_session || start_new_session
  end

  def resume_session
    if session = find_active_session_by_cookie
      session.resume(user_agent: request.user_agent, ip_address: request.remote_ip)
      Current.session = session
    end
  end

  def find_active_session_by_cookie
    Session.active.find_by(id: cookies.signed[:session_id]) if cookies.signed[:session_id]
  end

  def start_new_session
    Session.create!(user_agent: request.user_agent, ip_address: request.remote_ip).tap do |session|
      cookies.signed.permanent[:session_id] = { value: session.id, httponly: true, same_site: :lax }
      Current.session = session
    end
  end

  def terminate_session
    Current.session.destroy
    cookies.delete(:session_id)
  end
end
