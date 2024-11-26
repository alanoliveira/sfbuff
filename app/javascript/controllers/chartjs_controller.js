import { Controller } from "@hotwired/stimulus"
import Chart from 'chart.js/auto'
import { merge } from 'chart.js/helpers';
import visit_plugin from "../chartjs/visit_plugin"
import marks_plugin from "../chartjs/marks_plugin"

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
      plugins: [visit_plugin, marks_plugin]
    }, defaultOptions);
    this.chart = new Chart(this.element, mergedOptions)
  }
}
