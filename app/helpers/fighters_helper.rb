module FightersHelper
  def link_to_fighter(name, fighter_id)
    link_to name, "#"
  end

  def fighters_header_nav_link(name, url, **opts)
    opts[:class] = Array(opts[:class]) | [ "active" ] if current_page? send(url)
    link_to name, send(url, request.query_parameters), **opts
  end
end
