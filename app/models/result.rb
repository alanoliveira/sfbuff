Result = Data.define(:result) do
  const_set :WIN, new(1)
  const_set :LOSE, new(-1)
  const_set :DRAW, new(0)

  alias to_i result
  delegate :inquiry, to: :to_s
  delegate :win?, :lose?, :draw?, to: :inquiry

  def to_s
    case result
    when 1 then "win"
    when -1 then "lose"
    when 0 then "draw"
    end
  end
end
