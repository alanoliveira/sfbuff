Matchup::Result = Data.define(:id) do
  const_set :WIN, new(1)
  const_set :LOSS, new(-1)
  const_set :DRAW, new(0)

  alias to_i id
end
