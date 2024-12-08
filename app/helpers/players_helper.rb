module PlayersHelper
  def players_header_nav_link(name, url, **opts)
    opts[:class] = Array(opts[:class]) << "active" if current_page? url

    link_to name, url, **opts
  end
end
