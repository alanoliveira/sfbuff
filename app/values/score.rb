Score = Struct.new(:wins, :losses, :draws) do
  extend ActiveModel::Naming
  extend ActiveModel::Translation

  def self.empty
    allocate
  end

  def total
    wins.to_i + losses.to_i + draws.to_i unless empty?
  end

  def diff
    wins - losses unless empty?
  end

  def ratio
    (wins + (draws.to_f / 2)) / total.to_f * 100 unless empty?
  end

  def empty?
    deconstruct.all?(&:nil?)
  end

  def +(other)
    self.class.new(wins + other.wins, losses + other.losses, draws + other.draws)
  end
end
