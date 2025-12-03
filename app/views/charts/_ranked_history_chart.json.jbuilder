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
      json.visitOptions do
        json.frame "modal"
      end
    end

    json.localize do
      json.locale I18n.locale.to_s
    end

    json.marks do
      json.lp(
        1000 => { title: "IRON" },
        3000 => { title: "BRONZE" },
        5000 => { title: "SILVER" },
        9000 => { title: "GOLD" },
        13000 => { title: "PLATINUM" },
        19000 => { title: "DIAMOND" },
        25000 => { title: "MASTER" }
      )
      json.mr(
        1600 => { title: "HIGH" },
        1700 => { title: "GRAND" },
        1800 => { title: "ULTIMATE" })
    end
  end

  json.scales do
    if this.lp_matches.any?
      json.lp do
        json.stack "ranked"
        json.offset "true"
      end
    end

    if this.mr_matches.any?
      json.mr do
        json.stack "ranked"
        json.offset "true"
        json.stackWeight 8
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
    if this.mr_matches.any?
      json.child! do
        json.yAxisID "mr"
        json.label "MR"
        json.data this.mr_data
        json.tension 0.4
        json.borderColor ApplicationChart::CHART_COLORS[:blue]
        json.backgroundColor ApplicationChart::CHART_COLORS[:blue]
      end

      json.child! do
        json.yAxisID "mr"
        json.data this.future_mr_data
        json.tension 0.4
        json.borderColor ApplicationChart::CHART_COLORS[:blue]
        json.backgroundColor ApplicationChart::CHART_COLORS[:blue]
        json.borderDash [ 5, 5 ]
        json.fill false
        json.pointRadius 0
        json.pointHoverRadius 0
        json.pointHitRadius 0
      end
    end

    if this.lp_matches.any?
      json.child! do
        json.yAxisID "lp"
        json.label "LP"
        json.data this.lp_data
        json.tension 0.4
        json.borderColor ApplicationChart::CHART_COLORS[:red]
        json.backgroundColor ApplicationChart::CHART_COLORS[:red]
      end

      json.child! do
        json.yAxisID "lp"
        json.data this.future_lp_data
        json.tension 0.4
        json.borderColor ApplicationChart::CHART_COLORS[:red]
        json.backgroundColor ApplicationChart::CHART_COLORS[:red]
        json.borderDash [ 5, 5 ]
        json.fill false
        json.pointRadius 0
        json.pointHoverRadius 0
        json.pointHitRadius 0
      end
    end
  end
end
