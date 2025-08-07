steps = ranked_history.to_a
mr_steps, lp_steps = steps.partition { it.mr.positive? }

def create_entry(value:, date:, label:, replay_id:)
  visit = { path: replay_id, options: { frame: "modal" } } if replay_id

  {
    y: value,
    x: date.to_i * 1000,
    label:,
    visit:
  }
end

mr_items = mr_steps.map do |step|
  variation = step.mr_variation ? ("%+d" % step.mr_variation) : "?"
  create_entry(
    value: step.mr,
    date: step.played_at,
    label: "#{step.mr} (#{variation})",
    replay_id: step.replay_id
  )
end

lp_items = lp_steps.filter_map do |step|
  next if step.calibrating?
  variation = step.lp_variation ? ("%+d" % step.lp_variation) : "?"

  create_entry(
    value: step.lp,
    date: step.played_at,
    label: "#{step.lp} (#{variation})",
    replay_id: step.replay_id
  )
end

extra_step = ranked_history.extra_step
if extra_step.present?
  extra_mr_item = create_entry(
    value: extra_step["mr"],
    date: ranked_history.to_date.end_of_day,
    label: t(".current", value: extra_step["mr"]),
    replay_id: nil
  )

  extra_lp_item = create_entry(
    value: extra_step["lp"],
    date: ranked_history.to_date.end_of_day,
    label: t(".current", value: extra_step["lp"]),
    replay_id: nil
  )
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

    json.zoom do
      json.pan do
        json.enabled true
        json.mode "xy"
        json.modifierKey "ctrl"
      end

      json.zoom do
        json.wheel do
          json.enabled true
          json.modifierKey "ctrl"
        end

        json.pinch({ enabled: true })
        json.mode "xy"
      end

      json.limits do
        mr_min, mr_max = mr_steps.map(&:mr).minmax
        lp_min, lp_max = lp_steps.map(&:lp).minmax

        json.mr do
          json.min mr_min
          json.max mr_max
          json.minRange 10
        end

        json.lp do
          json.min lp_min
          json.max lp_max
          json.minRange 10
        end

        json.x do
          json.min (steps.first.played_at.to_i * 1000)
          json.max (steps.last.played_at.to_i * 1000)
          json.minRange 1.day.to_i * 1000
        end
      end
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
    if lp_items.any?
      json.lp do
        json.stack "ranked"
        json.offset "true"
      end
    end

    if mr_items.any?
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
    if lp_items.any?
      json.child! do
        json.yAxisID "lp"
        json.tension 0.4
        json.data lp_items
        json.borderColor ChartsHelper::CHART_COLORS[:red]
        json.backgroundColor ChartsHelper::CHART_COLORS[:red]
      end

      json.child! do
        json.yAxisID "lp"
        json.tension 0.4
        json.data [ lp_items.last, extra_lp_item ]
        json.borderColor ChartsHelper::CHART_COLORS[:red]
        json.backgroundColor ChartsHelper::CHART_COLORS[:red]
        json.borderDash [ 5, 5 ]
        json.fill false
        json.pointRadius 0
        json.pointHoverRadius 0
        json.pointHitRadius 0
      end if extra_lp_item
    end

    if mr_items.any?
      json.child! do
        json.yAxisID "mr"
        json.tension 0.4
        json.data mr_items
        json.borderColor ChartsHelper::CHART_COLORS[:blue]
        json.backgroundColor ChartsHelper::CHART_COLORS[:blue]
      end

      json.child! do
        json.yAxisID "mr"
        json.tension 0.4
        json.data [ mr_items.last, extra_mr_item ]
        json.borderColor ChartsHelper::CHART_COLORS[:blue]
        json.backgroundColor ChartsHelper::CHART_COLORS[:blue]
        json.borderDash [ 5, 5 ]
        json.fill false
        json.pointRadius 0
        json.pointHoverRadius 0
        json.pointHitRadius 0
      end if extra_mr_item
    end
  end
end
