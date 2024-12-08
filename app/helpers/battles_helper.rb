module BattlesHelper
  def round_badge(round)
    bg_color, text_color = case round
    when Round["L"] then [ "#2d3644", "#c7c7c8" ]
    when Round["V"] then [ "#2c003e", "#e297ff" ]
    when Round["C"] then [ "#003a3d", "#9bfaff" ]
    when Round["T"] then [ "#00123e", "#97b4ff" ]
    when Round["D"] then [ "#363636", "#cbcbcb" ]
    when Round["OD"] then [ "#113d00", "#bfffa6" ]
    when Round["SA"] then [ "#5f003a", "#ff93d5" ]
    when Round["CA"] then [ "#442600", "#ffd097" ]
    when Round["P"] then [ "#605c00", "#fffb97" ]
    end
    style = "width: 20px; background-color: #{bg_color}; color: #{text_color}"
    tag.span round.to_s, class: "badge px-0 text-center", style:
  end
end
