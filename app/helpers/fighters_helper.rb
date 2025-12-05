module FightersHelper
  def link_to_fighter(name, fighter, data: {}, **)
    data[:turbo_frame] ||= "_top"
    link_to(name, fighter_path(fighter), data:, **)
  end

  def fighter_header_nav_item(name, route_name, params: {})
    content_tag :li, class: "nav-item" do
      link_to name, url_for([ route_name, params ]), class: [ "nav-link", ("active" if current_page? route_name) ]
    end
  end

  def link_to_fighter_buckler_profile(fighter, **, &)
    link_to("https://www.streetfighter.com/6/buckler/profile/#{fighter.id}", target: "_blank", rel: "nofollow", **, &)
  end
end
