module ThemeSelectorHelper
  def theme_selector_option_button(value, &)
    content_tag(:button, type: "button", class: "dropdown-item d-flex align-items-center", data: {
      theme_selector_target: "option", theme_selector_theme_param: value, action: "theme-selector#switchTheme"
    }, &)
  end
end
