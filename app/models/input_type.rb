InputType = Data.define(:id, :name) do
  extend ActiveModel::Naming
  extend ActiveModel::Translation

  const_set :HASH, [
    new(0, "classic"),
    new(1, "modern")
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
end
