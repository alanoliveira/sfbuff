Rails.root.join("app/types/").each_child { require it }

ActiveRecord::Type.register(:round, RoundType)
ActiveRecord::Type.register(:fighter_banner, FighterBannerType)
