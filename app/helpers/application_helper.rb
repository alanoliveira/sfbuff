module ApplicationHelper
  include Pagy::Frontend

  def page_title(title)
    content_for(:title) { [ title, "SFBUFF" ].join(" - ") }
  end

  def alert(message = nil, kind: :info, dismissible: true)
    tag.div role: "alert", class: [ "alert", "alert-#{kind}", dismissible && "alert-dismissible" ] do
      concat block_given? ? yield : message
      concat button_tag("", type: "button", class: "btn-close", data: { bs_dismiss: "alert" }) if dismissible
    end
  end

  def toast(message = nil, kind: "primary")
    data = { controller: "toast" }
    render partial: "application/toast", locals: { message:, kind:, data: }
  end

  def error_message(error)
    t("errors.#{error}", default: t("errors.generic"))
  end

  def no_data_alert
    alert t("alerts.no_data"), kind: :warning
  end

  def cache(name = {}, options = {}, &block)
    super([ I18n.locale, name ], options, &block)
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

  def bs_spinner(kind: "border", size: nil, **opts, &)
    spinner_class = "spinner-#{kind}"
    spinner_size_class = "#{spinner_class}-#{size}" if size.present?
    tag.span class: [ spinner_class, spinner_size_class, opts.delete(:class) ], **opts do
      concat tag.span "Loading...", class: "visually-hidden"
      concat yield if block_given?
    end
  end
end
