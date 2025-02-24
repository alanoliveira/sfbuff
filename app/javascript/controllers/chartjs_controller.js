import { Controller } from "@hotwired/stimulus"
import "chartjs"
import marks from "chartjs-plugins/marks"
import visit from "chartjs-plugins/visit"
import bgColor from "chartjs-plugins/bg_color"

const merge = Chart.helpers.merge

const defaultOptions = {
  plugins: [visit, marks],
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

const downloadOptions = {
  options: {
    animation: false,
    responsive: false,
    pointStyle: false,
    plugins: {
      title: { display: true }
    }
  },
  plugins: [bgColor, marks]
}

// Connects to data-controller="ranked-history-chart"
export default class extends Controller {
  static targets = ["canvas", "downloadButton"]
  static values = {
    data: { type: Object },
  }

  connect() {
    this.downloadButtonTarget.addEventListener("click", this.downloadImage.bind(this))
    this.chart = new Chart(this.canvasTarget, this.chartOptions())
  }

  chartOptions() {
    return merge(this.dataValue, defaultOptions);
  }

  disconnect() {
    this.chart?.destroy()
  }

  downloadImage() {
    const downloadChart = new Chart(document.createElement("canvas"),
      merge(this.chartOptions(), downloadOptions))
    downloadChart.resize(800, 600)
    const anchor = document.createElement("a")
    anchor.href = downloadChart.toBase64Image()
    anchor.download = (new Date()).toISOString()
    anchor.click()
  }
}
