module AlertsHelper
  def alert(content = nil, type = "primary", dismissible: true, **opts, &)
    tag.div role: "alert", class: [ "alert", "alert-#{type}", ("alert-dismissible" if dismissible) ], **opts do
      concat content || capture(&)
      concat button_tag("", type: "button", class: "btn-close", data: { bs_dismiss: "alert" }) if dismissible
    end
  end

  def empty_alert_if(condition, &)
    if condition
      alert t("alerts.no_data"), "warning", dismissible: false, data: { test_id: "no-data-alert" }
    else
      capture(&)
    end
  end
end
