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
    opts = { data: { turbo_frame: "_top", turbo_prefetch: false } }.deep_merge(opts)
    link_to name, player_path(short_id), **opts
  end

  def mr_or_lp(mr: nil, lp: nil)
    return mr if mr.try(:positive?)
    lp if lp.try(:positive?)
  end

  def pick_span(character:, control_type:)
    tag.span "#{character.human_name} #{control_type}"
  end

  def signed_number(number)
    bs_class = case number
    when ..-1 then "text-danger"
    when 1.. then "text-success"
    else ""
    end
    tag.span format("%+d", number), class: bs_class
  end

  def percent_number(number)
    bs_class = case number
    when ..40 then "text-danger"
    when 60.. then "text-success"
    else ""
    end
    content_tag :span, number.round(2), class: bs_class
  end

  def bs_icon(icon, **opts)
    content_tag(:i, nil, class: [ "bi", "bi-#{icon}", opts.delete(:class) ], **opts)
  end
end
