Score = Struct.new(:wins, :losses, :draws) do
  extend ActiveModel::Naming
  extend ActiveModel::Translation

  def self.empty
    allocate
  end

  def +(other)
    self.class.new(wins + other.wins, losses + other.losses, draws + other.draws)
  end
end
