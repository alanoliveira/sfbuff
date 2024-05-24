import { Controller } from "@hotwired/stimulus"
import Chart from 'chart.js/auto';
import 'chartjs-adapter-date-fns';

export default class extends Controller {
  static targets = ["canvas"]
  static values = {
    data: Array,
    frame: String
  }

  connect() {
    this.chart = new Chart(this.canvasTarget, {
      type: 'line',
      data: {
        datasets: [{ data: this.dataValue, }]
      },
      options: {
        onClick: this.chartClick.bind(this),
        parsing: {
          xAxisKey: 'played_at',
          yAxisKey: 'points'
        },
        scales: {
          x: {
            display: true,
            type: 'timeseries',
            time: {
              unit: 'day',
              displayFormats: {
                day: 'yyyy-MM-dd HH:mm',
              }
            },
            ticks: {
              maxTicksLimit: 5,
            },
          },
        },
        plugins: {
          legend: { display: false },
          tooltip: {
            displayColors: false,
            callbacks: {
              label: ctx => ctx.raw.tooltip,
            }
          }
        }
      },
    });
  }

  chartClick(evt) {
    const elements = this.chart.getElementsAtEventForMode(evt, 'nearest', { intersect: true });
    if(elements.length > 0) {
      const element = elements[0];
      const data = this.dataValue[element.index];
      Turbo.visit(data['battle_url'], { frame: this.frameValue })
    }
  }
}
