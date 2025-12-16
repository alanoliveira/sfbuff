module ApplicationCable
  class Connection < ActionCable::Connection::Base
    include SwitchLocale
    include SwitchTimezone

    identified_by :current_session

    def connect
      set_current_session || reject_unauthorized_connection
    end

    private

    def set_current_session
      if session = Session.active.find_by(id: cookies.signed[:session_id])
        self.current_session = session
      end
    end
  end
end
