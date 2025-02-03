module RoundsHelper
  COLOR_MAP = {
   "L" =>  [ "#2d3644", "#c7c7c8" ],
   "V" =>  [ "#2c003e", "#e297ff" ],
   "C" =>  [ "#003a3d", "#9bfaff" ],
   "T" =>  [ "#00123e", "#97b4ff" ],
   "D" =>  [ "#363636", "#cbcbcb" ],
   "OD" => [ "#113d00", "#bfffa6" ],
   "SA" => [ "#5f003a", "#ff93d5" ],
   "CA" => [ "#442600", "#ffd097" ],
   "P" =>  [ "#605c00", "#fffb97" ]
  }

  def round_badge(round)
    bg_color, text_color = COLOR_MAP[round.name]
    style = "width: 20px; background-color: #{bg_color}; color: #{text_color}"
    tag.span round.name, class: "badge px-0 text-center", style:
  end
end
