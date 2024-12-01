class Round < EnumAttribute
  names[0] = "L"
  names[1] = "V"
  names[2] = "C"
  names[3] = "T"
  names[4] = "D"
  names[5] = "OD"
  names[6] = "SA"
  names[7] = "CA"
  names[8] = "P"

  def win?
    !lose? && !draw?
  end

  def lose?
    id == 0
  end

  def draw?
    id == 4
  end
end
