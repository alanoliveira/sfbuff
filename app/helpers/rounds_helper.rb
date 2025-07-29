module RoundsHelper
  COLOR_MAP = {
    0 => [ "#2D3644", "#C7C7C8" ],
    1 => [ "#2C003E", "#E297FF" ],
    2 => [ "#003A3D", "#9BFAFF" ],
    3 => [ "#00123E", "#97B4FF" ],
    4 => [ "#363636", "#CBCBCB" ],
    5 => [ "#113D00", "#BFFFA6" ],
    6 => [ "#5F003A", "#FF93D5" ],
    7 => [ "#442600", "#FFD097" ],
    8 => [ "#605C00", "#FFFB97" ]
  }

  def round_badge(round)
    bg_color, text_color = COLOR_MAP[round.to_i]
    style = "width: 20px; background-color: #{bg_color}; color: #{text_color}"
    tag.span Enums::ROUNDS[round.to_i], class: "badge px-0 text-center", style:
  end
end
