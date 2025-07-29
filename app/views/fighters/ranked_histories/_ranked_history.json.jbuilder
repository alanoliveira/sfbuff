mr_steps, lp_steps = ranked_history.partition { it.mr.positive? }

mr_steps = mr_steps.map do |step|
  variation = step.mr_variation ? ("%+d" % step.mr_variation) : "?"

  {
    y: step.mr,
    x: step.played_at.as_json,
    label: "#{step.mr} (#{variation})",
    visit: { path: step.replay_id, options: { frame: "modal" } }
  }
end

lp_steps = lp_steps.map do |step|
  variation = step.lp_variation ? ("%+d" % step.lp_variation) : "?"

  {
    y: step.lp,
    x: step.played_at.as_json,
    label: "#{step.lp} (#{variation})",
    visit: { path: step.replay_id, options: { frame: "modal" } }
  }
end

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

    json.tooltip do
      json.displayColors false
    end

    json.visit do
      json.baseUrl battle_path(replay_id: "")
    end

    json.localize do
      json.locale I18n.locale.to_s
    end

    json.title do
      json.text [
        RankedHistory.model_name.human,
        character_name(ranked_history.character_id.to_i),
        "#{ranked_history.from_date} ~ #{ranked_history.to_date}"
      ].join(" - ")
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
    if lp_steps.any?
      json.lp do
        json.stack "ranked"
        json.offset "true"
      end
    end

    if mr_steps.any?
      json.mr do
        json.stack "ranked"
        json.offset "true"
        json.stackWeight 4
      end
    end

    json.x do
      json.type "timeseries"

      json.time do
        json.unit "day"
        json.displayFormats do
          json.day "P HH:mm"
        end
      end

      json.adapters do
        json.date do
          json.locale nil
        end
      end
    end
  end
end

json.data do
  json.datasets do
    if lp_steps.any?
      json.child! do
        json.yAxisID "lp"
        json.tension 0.4
        json.data lp_steps
        json.borderColor ChartsHelper::CHART_COLORS[:red]
        json.backgroundColor ChartsHelper::CHART_COLORS[:red]
      end
    end

    if mr_steps.any?
      json.child! do
        json.yAxisID "mr"
        json.tension 0.4
        json.data mr_steps
        json.borderColor ChartsHelper::CHART_COLORS[:blue]
        json.backgroundColor ChartsHelper::CHART_COLORS[:blue]
      end
    end
  end
end
