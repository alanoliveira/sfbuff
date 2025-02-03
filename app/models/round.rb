Round = Data.define(:id, :name) do
  cattr_reader :enum, default: [
    new(id: 0, name: "L"),
    new(id: 1, name: "V"),
    new(id: 2, name: "C"),
    new(id: 3, name: "T"),
    new(id: 4, name: "D"),
    new(id: 5, name: "OD"),
    new(id: 6, name: "SA"),
    new(id: 7, name: "CA"),
    new(id: 8, name: "P")
  ].freeze

  class << self
    include Enumerable

    private :new
    delegate :each, to: :enum

    def [](id)
      find { it.id == id } || new(id:, name: "?")
    end
  end

  delegate :to_i, :to_s, to: :id

  def result
    case id
    when 0 then Result::LOSE
    when 4 then Result::DRAW
    else Result::WIN
    end
  end
end
