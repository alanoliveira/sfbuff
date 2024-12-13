module Players::MatchupScope
  def cache(*, **opts, &)
    opts[:version] = Array(opts[:version]) << @player.latest_replay_id
    super(*, **opts, &)
  end

  def params
    super.with_defaults(
      home_short_id: @player&.short_id&.to_i,
    )
  end
end
