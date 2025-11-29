Round = Data.define(:id, :name, :result) do
  extend ActiveModel::Naming

  const_set :ALL, [
    [ 0, "L",  Result::LOSS ],
    [ 1, "V",  Result::WIN  ],
    [ 2, "C",  Result::WIN  ],
    [ 3, "T",  Result::WIN  ],
    [ 4, "D",  Result::DRAW ],
    [ 5, "OD", Result::WIN  ],
    [ 6, "SA", Result::WIN  ],
    [ 7, "CA", Result::WIN  ],
    [ 8, "P",  Result::WIN  ]
  ].map { |id, name, result| const_set(name.upcase, new(id, name, result)) }

  class << self
    def [](id)
      all.find { it.id == id }
    end

    def all
      const_get(:ALL)
    end
  end

  delegate :to_i, :to_s, :as_json, to: :id
  delegate :win?, :loss?, :draw?, to: :result
end
