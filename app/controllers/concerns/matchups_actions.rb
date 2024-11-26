module MatchupsActions
  def battles(matchups)
    @pagy, @battles = pagy(matchups.includes(:p1, :p2).ordered.reverse_order)
    @score = cache([ matchups.cache_key, "score" ]) { matchups.performance.sum }
    render "matchups/battles"
  end

  def rivals(matchups)
    performance = matchups.performance.group_by_rival.limit(8)
    rivals = [ :favorites, :tormentors, :victims ].index_with do |name|
      performance.public_send(name)
    end
    render partial: "matchups/rivals", locals: { rivals: }
  end

  def matchup_chart(matchups)
    @matchup_chart = MatchupChart.from_matchup(matchups)
    render "matchups/matchup_chart"
  end

  def filter_matchups(*permitted)
    MatchupsFilter.filter(Matchup, params.permit(*permitted))
  end
end
