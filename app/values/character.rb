Character = Data.define(:id, :name) do
  extend ActiveModel::Naming
  extend ActiveModel::Translation

  const_set :ALL, [
    [ 1, "ryu" ],
    [ 2, "luke" ],
    [ 3, "kimberly" ],
    [ 4, "chun_li" ],
    [ 5, "manon" ],
    [ 6, "zangief" ],
    [ 7, "jp" ],
    [ 8, "dhalsim" ],
    [ 9, "cammy" ],
    [ 10, "ken" ],
    [ 11, "dee_jay" ],
    [ 12, "lilly" ],
    [ 13, "aki" ],
    [ 14, "rashid" ],
    [ 15, "blanka" ],
    [ 16, "juri" ],
    [ 17, "marisa" ],
    [ 18, "guile" ],
    [ 19, "ed" ],
    [ 20, "e_honda" ],
    [ 21, "jamie" ],
    [ 22, "akuma" ],
    [ 25, "sagat" ],
    [ 26, "m_bison" ],
    [ 27, "terry" ],
    [ 28, "mai" ],
    [ 29, "elena" ],
    [ 30, "c_viper" ],
    [ 254, "random" ]
  ].map { |id, name| new(id, name) }

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
