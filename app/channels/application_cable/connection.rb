module ApplicationCable
  class Connection < ActionCable::Connection::Base
    include Internationalizable

    around_command :switch_locale, :switch_timezone
  end
end
