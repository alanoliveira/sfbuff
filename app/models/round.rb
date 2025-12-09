Round = Data.define(:id, :name, :result) do
  extend ActiveModel::Naming
  extend ActiveModel::Translation

  const_set :HASH, [
    new(0, "L",  Result::LOSS),
    new(1, "V",  Result::WIN),
    new(2, "C",  Result::WIN),
    new(3, "T",  Result::WIN),
    new(4, "D",  Result::DRAW),
    new(5, "OD", Result::WIN),
    new(6, "SA", Result::WIN),
    new(7, "CA", Result::WIN),
    new(8, "P",  Result::WIN)
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

  delegate :to_i, :to_s, :as_json, to: :id
  delegate :win?, :loss?, :draw?, to: :result
end
