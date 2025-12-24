import { Controller } from "@hotwired/stimulus"
import "chartjs"
import "chartjs-adapter-date-fns"
import { Visit, Localizer, Tiptool, Marks, BgColor } from "chartjs-plugins"

Chart.register(Visit, Localizer, Tiptool, Marks);

const DOWNLOAD_OPTIONS = {
  plugins: [ BgColor ],
  options: {
    animation: false,
    responsive: false,
    pointStyle: false,
    plugins: {
      title: { display: true },
      bgColor: { color: "#FFFFFF" }
    }
  }
}

// Connects to data-controller="chartjs"
export default class extends Controller {
  static targets = ["canvas", "downloadButton"]
  static values = {
    data: { type: Object },
  }

  connect() {
    this.chart = new Chart(this.canvasTarget, this.dataValue)
    this.downloadButtonTarget.addEventListener("click", this.downloadImage.bind(this))
  }

  disconnect() {
    this.chart?.destroy()
  }

  downloadImage() {
    const canvas = document.createElement("canvas")
    canvas.width = "1200"
    canvas.height = "600"
    const downloadChart = new Chart(canvas, Chart.helpers.merge(this.dataValue, DOWNLOAD_OPTIONS))
    const anchor = document.createElement("a")
    anchor.href = downloadChart.toBase64Image()
    anchor.download = (new Date()).toISOString()
    anchor.click()
  }
}
