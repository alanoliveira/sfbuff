module FightersHelper
  def fighter_header_nav_item(name, route_name, params: {})
    content_tag :li, class: "nav-item" do
      link_to name, url_for([ route_name, params ]), class: [ "nav-link", ("active" if current_page? route_name) ]
    end
  end
end
