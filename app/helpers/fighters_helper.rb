module FightersHelper
  def link_to_fighter(name, fighter_id, data: {}, **)
    data[:turbo_frame] ||= "_top"
    link_to name, fighter_path(fighter_id), data:, **
  end

  def fighters_header_nav_link(name, url, **opts)
    opts[:class] = Array(opts[:class]) | [ "active" ] if current_page? send(url)
    link_to name, send(url, request.query_parameters), **opts
  end
end
