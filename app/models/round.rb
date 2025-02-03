Round = Data.define(:round) do
  def result
    case round
    when 0 then Result::LOSE
    when 4 then Result::DRAW
    else Result::WIN
    end
  end

  def to_s
    case round
    when 0 then "L"
    when 1 then "V"
    when 2 then "C"
    when 3 then "T"
    when 4 then "D"
    when 5 then "OD"
    when 6 then "SA"
    when 7 then "CA"
    when 8 then "P"
    else ""
    end
  end
end
