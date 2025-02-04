Character = Data.define(:id, :name) do
  cattr_reader :enum, default: [
    new(id: 1, name: "ryu"),
    new(id: 2, name: "luke"),
    new(id: 3, name: "kimberly"),
    new(id: 4, name: "chun_li"),
    new(id: 5, name: "manon"),
    new(id: 6, name: "zangief"),
    new(id: 7, name: "jp"),
    new(id: 8, name: "dhalsim"),
    new(id: 9, name: "cammy"),
    new(id: 10, name: "ken"),
    new(id: 11, name: "dee_jay"),
    new(id: 12, name: "lilly"),
    new(id: 13, name: "aki"),
    new(id: 14, name: "rashid"),
    new(id: 15, name: "blanka"),
    new(id: 16, name: "juri"),
    new(id: 17, name: "marisa"),
    new(id: 18, name: "guile"),
    new(id: 19, name: "ed"),
    new(id: 20, name: "e_honda"),
    new(id: 21, name: "jamie"),
    new(id: 22, name: "akuma"),
    new(id: 26, name: "m_bison"),
    new(id: 27, name: "terry"),
    new(id: 28, name: "mai"),
    new(id: 254, name: "random")
  ].freeze

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
