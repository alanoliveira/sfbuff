module LeagueInfosHelper
  def league_info_span(league_info, **)
    content = if league_info.mr?
      "#{league_info.mr} MR"
    elsif league_info.lp?
      "#{league_info.lp} LP"
    else
      ""
    end
    tag.span content, **
  end
end
