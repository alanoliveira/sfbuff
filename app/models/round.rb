Round = Data.define(:id) do
  delegate :to_i, to: :id

  def loss?
    id == 0
  end

  def draw?
    id == 4
  end

  def win?
    !loss? && !draw?
  end
end
