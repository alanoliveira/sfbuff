module Players::MatchupScope
  def cache(*, **opts, &)
    opts[:version] = Array(opts[:version]) << @player.latest_replay_id
    super(*, **opts, &)
  end
end
