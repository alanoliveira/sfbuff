module ComponentsHelper
  def color_mode_select
    render "shared/color_mode_select", options: {
      "light" => "brightness-high-fill",
      "dark" => "moon-fill",
      "auto" => "circle-half"
    }
  end

  def locale_select
    render "shared/locale_select", selected: I18n.locale, options: {
      "English" => :en,
      "Português" => :"pt-BR",
      "日本語" => :ja
    }
  end
end
