module ApplicationHelper
  def page_title(title = nil)
    content_for :title, [ title, "SFBUFF" ].join(" - ")
  end

  def alert(content = nil, type: "success", dismissible: true, **opts, &)
    content ||= capture(&)
    tag.div role: "alert", class: [ "alert", "alert-#{type}", ("alert-dismissible" if dismissible) ] do
      concat content
      concat button_tag("", type: "button", class: "btn-close", data: { bs_dismiss: "alert" }) if dismissible
    end
  end

  def icon(icon, **opts)
    tag.i nil, class: [ "bi", "bi-#{icon}", opts.delete(:class) ], **opts
  end
end
