module ApplicationCable
  class Connection < ActionCable::Connection::Base
    include SwitchLocale

    identified_by :current_session

    def connect
      set_current_session || reject_unauthorized_connection
    end

    private

    def set_current_session
      if session = Session.find_by(id: cookies.signed[:session_id])
        self.current_session = session
      end
    end
  end
end
