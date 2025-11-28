module FormsHelper
  def auto_submit_form_with(data: {}, **attributes)
    data[:controller] = "auto-submit #{data[:controller]}".strip
    form_with data: data, **attributes do
      yield if block_given?
    end
  end
end
