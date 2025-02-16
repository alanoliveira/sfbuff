module ApplicationHelper
  def page_title(title = nil)
    content_for :title, [ title, "SFBUFF" ].join(" - ")
  end

  def alert(content = nil, type = "success", dismissible: true, **opts, &)
    content ||= capture(&)
    tag.div role: "alert", class: [ "alert", "alert-#{type}", ("alert-dismissible" if dismissible) ] do
      concat content
      concat button_tag("", type: "button", class: "btn-close", data: { bs_dismiss: "alert" }) if dismissible
    end
  end

  def icon(icon, **opts)
    tag.i nil, class: [ "bi", "bi-#{icon}", opts.delete(:class) ], **opts
  end

  def empty_alert_unless(condition, &)
    return alert t("alerts.no_data"), "warning", dismissible: false unless condition
    capture(&)
  end

  def error_message(error)
    return error.message unless Rails.env.production?
    t("errors.#{error.class.name}", default: t("errors.generic"))
  end

  def share_please_toast
    return if Time.at(session["share_me_displayed_at"].to_i) > 6.hours.ago
    session["share_me_displayed_at"] = Time.now.to_i
    simple_toast t("alerts.share_please"), data: { toast_wait_value: 15000 }
  end
end
