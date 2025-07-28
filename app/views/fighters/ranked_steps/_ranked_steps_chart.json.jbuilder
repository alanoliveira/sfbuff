mr_steps, lp_steps = ranked_steps
  .sort_by(&:played_at)
  .partition { it.mr.positive? }

mr_steps = mr_steps.chain([ nil ]).each_cons(2).map do |step1, step2|
  variation = step2.nil? ? "?" : ("%+d" % (step2.mr - step1.mr))

  {
    y: step1.mr,
    x: l(step1.played_at, format: :short),
    label: "#{step1.mr} (#{variation})",
    visit: { url: battle_path(step1.replay_id), options: { frame: "modal" } }
  }
end

lp_steps = lp_steps.chain([ nil ]).each_cons(2).map do |step1, step2|
  variation = step2.nil? ? "?" : ("%+d" % (step2.lp - step1.lp))

  {
    y: step1.lp,
    x: l(step1.played_at, format: :short),
    label: "#{step1.lp} (#{variation})",
    visit: { url: battle_path(step1.replay_id), options: { frame: "modal" } }
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

    json.title do
      json.text "#{RankedStep.model_name.human}"
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
