import { Controller } from "@hotwired/stimulus"
import Chart from 'chart.js/auto'

const CHART_COLORS = {
  red: 'rgb(255, 99, 132)',
  blue: 'rgb(54, 162, 235)',
};

// Connects to data-controller="matchups-group-by-date-chart"
export default class extends Controller {
  static targets = ["canvas"]
  static values = { data: Array }

  connect() {
    this.chart = new Chart(this.canvasTarget, {
      type: 'bar',
      data: {
        labels: this.dataValue.map(d => d.label),
        datasets: [{
          data: this.dataValue.map(d => d.value),
          minBarLength: 2,
          backgroundColor: this.dataValue.map(d => d.value < 0 ? CHART_COLORS.red : CHART_COLORS.blue)
        }],
      },
      options: {
        animation: {
          duration: 0
        },
        plugins: {
          legend: { display: false },
          tooltip: {
            displayColors: false,
            callbacks: {
              label: ctx => this.dataValue[ctx.dataIndex].description
            },
          },
        },
      }
    })
  }
}
