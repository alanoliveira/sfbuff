import { Controller } from "@hotwired/stimulus"
import Chart from 'chart.js/auto'
import "chart.js/auto"
import visit_plugin from "../chartjs/visit_plugin"
import marks_plugin from "../chartjs/marks_plugin"

// Connects to data-controller="ranked-history-chart"
export default class extends Controller {
  static values = {
    type: { type: String, default: "line" },
    data: { type: Object },
    options: { type: Object, default: {} },
  }

  connect() {
    this.chart = new Chart(this.element, {
      type: this.typeValue,
      data: this.dataValue,
      options: this.optionsValue,
      plugins: [visit_plugin, marks_plugin]
    })
  }
}
