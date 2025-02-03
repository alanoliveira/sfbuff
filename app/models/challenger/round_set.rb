class Challenger::RoundSet
  include Enumerable

  delegate :each, to: :@rounds

  def initialize(round_ids)
    @rounds = round_ids.map { Round[it] }
  end

  def result
    case map { it.result.to_i }.sum
    when 1.. then Result::WIN
    when ..-1 then Result::LOSE
    else Result::DRAW
    end
  end
end
