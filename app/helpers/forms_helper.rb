module FormsHelper
  def auto_submit_form_with(data: {}, delay: nil, **opts, &)
    data[:controller] = [ "auto-submit", data[:controller] ].compact.join
    data[:auto_submit_delay_value] = delay if delay

    form_with data:, **opts do
      yield if block_given?
    end
  end
end
