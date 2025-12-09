Character = Data.define(:id, :name) do
  extend ActiveModel::Naming
  extend ActiveModel::Translation

  const_set :HASH, [
    new(1,   "ryu"),
    new(2,   "luke"),
    new(3,   "kimberly"),
    new(4,   "chun_li"),
    new(5,   "manon"),
    new(6,   "zangief"),
    new(7,   "jp"),
    new(8,   "dhalsim"),
    new(9,   "cammy"),
    new(10,  "ken"),
    new(11,  "dee_jay"),
    new(12,  "lilly"),
    new(13,  "aki"),
    new(14,  "rashid"),
    new(15,  "blanka"),
    new(16,  "juri"),
    new(17,  "marisa"),
    new(18,  "guile"),
    new(19,  "ed"),
    new(20,  "e_honda"),
    new(21,  "jamie"),
    new(22,  "akuma"),
    new(25,  "sagat"),
    new(26,  "m_bison"),
    new(27,  "terry"),
    new(28,  "mai"),
    new(29,  "elena"),
    new(30,  "c_viper"),
    new(254, "random")
  ].index_by(&:id)

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
