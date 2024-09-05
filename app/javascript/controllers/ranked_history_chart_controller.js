import { Controller } from "@hotwired/stimulus"
import Chart from 'chart.js/auto'
import marksPlugin from '../chartjs/marks_plugin'

// Connects to data-controller="ranked-history-chart"
export default class extends Controller {
  static targets = ["canvas"]
  static values = {
    lpData: Array,
    mrData: Array,
    lpMarks: Object
  }

  connect() {
    this.chart = new Chart(this.canvasTarget, {
      type: 'line',
      data: { datasets: this.getDatasets() },
      options: {
        onClick: this.chartClick.bind(this),
        layout: {
          padding: { left: 30 }
        },
        plugins: {
          legend: { display: false },
          tooltip: {
            displayColors: false,
            callbacks: {
              label: ctx => ctx.raw.label,
              title: ctxs => ctxs[0].raw.title,
            },
          },
        },
        scales: this.getScales(),
        lpMarks: this.lpMarksValue
      },
      plugins: [marksPlugin]
    })
  }

  getScales() {
    let scales = { }

    if (this.lpDataValue.length) {
      scales["lp"] = { stack: 'ranked', offset: true }
    }
    if (this.mrDataValue.length) {
      scales["mr"] = { stack: 'ranked', offset: true }
    }

    return scales
  }

  getDatasets() {
    let datasets = []
    if (this.lpDataValue.length) {
      datasets.push({ data: this.lpDataValue, yAxisID: "lp" })
    }
    if (this.mrDataValue.length) {
      datasets.push({ data: this.mrDataValue, yAxisID: "mr" })
    }

    return datasets
  }

  chartClick(evt) {
    const elements = this.chart.getElementsAtEventForMode(evt, 'nearest', { intersect: true })
    const element = elements[0]
    if (element) {
      const data = element.element.$context.raw
      Turbo.visit(data.link, { frame: "turbo-modal" })
    }
  }
}
