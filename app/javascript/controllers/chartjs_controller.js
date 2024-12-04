import { Controller } from "@hotwired/stimulus"
import { Chart, registerables } from "chartjs"
import { merge } from "chartjs/helpers"
import marks from "chartjs-plugins/marks"
import visit from "chartjs-plugins/visit"

Chart.register(...registerables);

const defaultOptions = {
  options: {
    plugins: {
      tooltip: {
        callbacks: {
          title: ctxs => ctxs[0].raw.title,
          label: ctx => ctx.raw.label
        }
      }
    }
  }
}

// Connects to data-controller="ranked-history-chart"
export default class extends Controller {
  static values = {
    type: { type: String, default: "line" },
    data: { type: Object },
    options: { type: Object, default: {} },
  }

  connect() {
    const mergedOptions = merge({
      type: this.typeValue,
      data: this.dataValue,
      options: this.optionsValue,
      plugins: [visit, marks]
    }, defaultOptions);

    this.chart = new Chart(this.element, mergedOptions)
  }

  disconnect() {
    if (!this.chart) return
    this.chart.destroy()
  }
}
