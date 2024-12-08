module ApplicationHelper
  include Pagy::Frontend

  def page_title(title)
    content_for(:title) { [ title, "SFBUFF" ].join(" - ") }
  end

  def bs_icon(icon, **opts)
    content_tag(:i, nil, class: [ "bi", "bi-#{icon}", opts.delete(:class) ], **opts)
  end
end
