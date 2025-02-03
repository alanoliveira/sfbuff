master_rating_steps, league_point_steps = ranked_history.map do |item|
  type, point, variation = if item.master_rating.zero?
    [ "lp", item.league_point, item.league_point_variation ]
  else
    [ "mr", item.master_rating, item.master_rating_variation ]
  end

  total = point + variation.to_i
  variation_label = variation.nil? ? "?" : ("%+d" % variation)
  {
    y: total,
    x: l(item.played_at, format: :short),
    label: "#{total} (#{variation_label})",
    visit: { url: battle_path(item.replay_id), options: { frame: "modal" } },
    type:
  }
end.partition { it[:type] == "mr" }

json.type "line"

json.options do
  json.layout do
    json.padding do
      json.left 30
    end
  end

  json.plugins do
    json.legend do
      json.display false
    end

    json.title do
      from_title = l ranked_history.played_from, format: :short if ranked_history.played_from
      to_title = l ranked_history.played_to, format: :short if ranked_history.played_to
      json.text "#{RankedHistory.model_name.human} - #{character_name ranked_history.character} - #{from_title}~#{to_title}"
    end

    json.tooltip do
      json.displayColors false
    end

    json.marks do
      json.lp(
        1000 => { title: "IRON" },
        3000 => { title: "BRONZE" },
        5000 => { title: "SILVER" },
        9000 => { title: "GOLD" },
        13000 => { title: "PLATINUM" },
        19000 => { title: "DIAMOND" },
        25000 => { title: "MASTER" })
      json.mr(
        1600 => { title: "HIGH" },
        1700 => { title: "GRAND" },
        1800 => { title: "ULTIMATE" })
    end

    json.visit do
      json.property "visit"
    end
  end

  json.scales do
    if league_point_steps.any?
      json.lp do
        json.stack "ranked"
        json.offset "true"
      end
    end

    if master_rating_steps.any?
      json.mr do
        json.stack "ranked"
        json.offset "true"
        json.stackWeight 4
      end
    end
  end
end

json.data do
  json.datasets do
    if league_point_steps.any?
      json.child! do
        json.yAxisID "lp"
        json.tension 0.4
        json.data league_point_steps
        json.borderColor ChartsHelper::CHART_COLORS[:red]
        json.backgroundColor ChartsHelper::CHART_COLORS[:red]
      end
    end

    if master_rating_steps.any?
      json.child! do
        json.yAxisID "mr"
        json.tension 0.4
        json.data master_rating_steps
        json.borderColor ChartsHelper::CHART_COLORS[:blue]
        json.backgroundColor ChartsHelper::CHART_COLORS[:blue]
      end
    end
  end
end
