import { Controller } from "@hotwired/stimulus"
import "chartjs"

// Connects to data-controller="chartjs"
export default class extends Controller {
  static targets = ["canvas"]
  static values = {
    data: { type: Object },
  }

  connect() {
    this.chart = new Chart(this.canvasTarget, this.dataValue)
  }

  disconnect() {
    this.chart?.destroy()
  }
}
