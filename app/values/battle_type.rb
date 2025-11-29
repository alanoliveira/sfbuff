BattleType = Data.define(:id, :name) do
  extend ActiveModel::Naming

  const_set :ALL, [
    [ 1, "ranked" ],
    [ 2, "casual_match" ],
    [ 3, "battle_hub" ],
    [ 4, "custom_room" ]
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
