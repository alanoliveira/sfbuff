module ComponentsHelper
  def color_mode_select
    render "shared/color_mode_select", options: {
      "light" => "brightness-high-fill",
      "dark" => "moon-fill",
      "auto" => "circle-half"
    }
  end
end
