module LeagueInfosHelper
  def league_info_span(mr:, lp:, **)
    content = if mr.positive?
      "#{mr} MR"
    elsif lp.positive?
      "#{lp} LP"
    else
      ""
    end
    tag.span content, **
  end
end
