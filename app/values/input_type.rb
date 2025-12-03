InputType = Data.define(:id, :name) do
  extend ActiveModel::Naming
  extend ActiveModel::Translation

  const_set :ALL, [
    [ 0, "classic" ],
    [ 1, "modern" ]
  ].map { |id, name| const_set(name.upcase, new(id, name)) }

  class << self
    def [](id)
      all.find { it.id == id }
    end

    def all
      const_get(:ALL)
    end
  end

  delegate :to_i, :to_s, :as_json, to: :id
end
