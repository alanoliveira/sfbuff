module ApplicationCable
  class Connection < ActionCable::Connection::Base
    include SwitchTimezone
    include SwitchLocale

    around_command :switch_timezone, :switch_locale

    identified_by :session_id

    def connect
      reject_unauthorized_connection if request.session.id.blank?
      self.session_id = request.session.id
      logger.add_tags session_id
    end
  end
end
