Result = Data.define(:id, :name) do
  extend ActiveModel::Naming
  extend ActiveModel::Translation

  const_set :ALL, [
    [ 1, "win" ],
    [ 0, "draw" ],
    [ -1, "loss" ]
  ].map { |id, name| const_set(name.upcase, new(id, name)) }

  class << self
    def [](id)
      all.find { it.id == id }
    end

    def all
      const_get(:ALL)
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
