Result = Data.define(:id, :name) do
  extend ActiveModel::Naming
  extend ActiveModel::Translation

  const_set :HASH, [
    new(-1, "loss"),
    new(0, "draw"),
    new(1, "win")
  ].index_by(&:id)

  const_get(:HASH).values.each { const_set(it.name.upcase, it) }

  class << self
    def [](id)
      const_get(:HASH)[id] || new(id, "?")
    end

    def all
      const_get(:HASH).values
    end
  end

  def win?
    self == Result::WIN
  end

  def loss?
    self == Result::LOSS
  end

  def draw?
    self == Result::DRAW
  end

  delegate :to_i, :to_s, :as_json, to: :id
end
