function addMarks(scale, marks, ctx) {
  Object.entries(scale.ticks).forEach(([_, tick]) => {
    if (marks[tick.value]) { tick.label = "" }
  })

  Object.entries(marks).forEach(([points, data]) => {
    if (points > scale.start) {
      const pixelForValue = scale.getPixelForValue(points)
      ctx.strokeRect(scale.chart.chartArea.left, pixelForValue, scale.chart.chartArea.width, 0)
      ctx.textAlign = "right"
      ctx.font = `bold ${ctx.font}`
      ctx.fillText(data.title, scale.chart.chartArea.left - 1, pixelForValue)
    }
  })
}

export default {
  id: "marks",
  beforeDraw: chart => {
    const config = chart.config.options.plugins.marks
    if (!config) { return }

    const { ctx, scales } = chart
    Object.entries(config).forEach(([scale_name, marks]) => {
      const scale = scales[scale_name]
      if (scale) addMarks(scale, marks, ctx)
    })
  }
}
