function addYMarks(x, y, marks, ctx) {
  Object.entries(y.ticks).forEach(([_, tick]) => {
    if (marks[tick.value]) {
      tick.label = ""
    }
  })

  Object.entries(marks).forEach(([points, data]) => {
    if (points > y.start) {
      const pixel_for_rank = y.getPixelForValue(points)
      ctx.strokeRect(x.left, pixel_for_rank, x.width, 0)
      ctx.textAlign = "right"
      ctx.font = `bold ${ctx.font}`
      ctx.fillText(data.name, x.left - 3, pixel_for_rank)
    }
  })
}

export default {
  id: "marks",
  beforeDraw: chart => {
    const { ctx, scales: { x, lp } } = chart
    if(lp) { addYMarks(x, lp, chart.config.options.lpMarks, ctx) }
  }
}
