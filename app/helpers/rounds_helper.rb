module RoundsHelper
  COLOR_MAP = {
    "L"  => [ "#2D3644", "#C7C7C8" ],
    "V"  => [ "#2C003E", "#E297FF" ],
    "C"  => [ "#003A3D", "#9BFAFF" ],
    "T"  => [ "#00123E", "#97B4FF" ],
    "D"  => [ "#363636", "#CBCBCB" ],
    "OD" => [ "#113D00", "#BFFFA6" ],
    "SA" => [ "#5F003A", "#FF93D5" ],
    "CA" => [ "#442600", "#FFD097" ],
    "P"  => [ "#605C00", "#FFFB97" ]
  }

  def round_badge(round)
    bg_color, text_color = COLOR_MAP[round.name]
    style = "width: 20px; background-color: #{bg_color}; color: #{text_color}"
    tag.span round.name, class: "badge px-0 text-center", style:
  end
end
