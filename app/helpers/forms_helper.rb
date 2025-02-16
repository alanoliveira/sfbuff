module FormsHelper
  def auto_submit_form_with(data: {}, delay: nil, **opts, &)
    data[:controller] = [ "auto-submit", data[:controller] ].compact.join
    data[:auto_submit_delay_value] = delay if delay

    form_with data:, **opts do |f|
      yield f if block_given?
    end
  end

  def filter_form_with(data: {}, **opts, &)
    opts[:url] ||= false
    opts[:scope] ||= ""
    opts[:method] ||= "get"
    data[:controller] = "form-helper #{data[:controller]}".strip
    data[:form_helper_compact_blank_value] = true
    form_with data:, **opts, &
  end

  def form_reset_button(data: {}, **opts)
    data[:turbo_prefetch] = false
    link_to t("buttons.reset"), false, data:, **opts
  end
end
