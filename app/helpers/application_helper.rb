module ApplicationHelper
  include Pagy::Frontend

  def page_title(title)
    content_for(:title) { [ title, "SFBUFF" ].join(" - ") }
  end

  def alert(message = nil, kind: :info, **opts, &)
    opts[:class] = Array(opts[:class]) | [ "alert", "alert-#{kind}" ]
    tag.div(message, role: "alert", **opts, &)
  end

  def no_data_alert
    alert t("alerts.no_data"), kind: :warning
  end

  def link_to_player(name, short_id, **opts)
    opts = { data: { turbo_frame: "_top" } }.deep_merge(opts)
    link_to name, player_path(short_id), **opts
  end

  def mr_or_lp(mr: nil, lp: nil)
    return "#{mr} MR" if mr.try(:positive?)
    "#{lp} LP" if lp.try(:positive?)
  end

  def pick_span(character:, control_type:)
    tag.span "#{character.human_name} #{control_type}"
  end

  def bs_icon(icon, **opts)
    content_tag(:i, nil, class: [ "bi", "bi-#{icon}", opts.delete(:class) ], **opts)
  end
end
