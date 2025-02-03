LeagueInfo = Struct.new(:lp, :mr) do
  def mr?
    mr.positive?
  end

  def lp?
    lp.positive?
  end
end
