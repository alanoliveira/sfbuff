module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :session_id

    def connect
      reject_unauthorized_connection if request.session.id.blank?
      self.session_id = request.session.id
    end
  end
end
