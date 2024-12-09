module PlayersHelper
  def players_header_nav_link(name, url, **opts)
    opts[:class] = Array(opts[:class]) << "active" if current_page? url
    url = "#{url}?#{request.query_string}" if request.query_string.present?

    link_to name, url, **opts
  end
end
