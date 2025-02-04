InputType = Data.define(:id, :name) do
  cattr_reader :enum, default: [
    new(id: 0, name: "C"),
    new(id: 1, name: "M")
  ]

  class << self
    include Enumerable

    private :new
    delegate :each, to: :enum

    def [](val)
      id = val.to_i
      find { it.id == id } || new(id:, name: "?")
    end
  end

  delegate :to_i, :to_s, to: :id
end
