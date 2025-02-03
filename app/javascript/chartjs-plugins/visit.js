export default {
  id: "visit",
  afterDraw: chart => {
    const config = chart.config.options.plugins.visit
    if (!config) { return }

    chart.options.onClick = evt => {
      const elements = chart.getElementsAtEventForMode(evt, 'nearest', { intersect: true })
      const firstPoint = elements[0]
      if (!firstPoint) return

      const item = chart.data.datasets[firstPoint.datasetIndex].data[firstPoint.index];
      const visitTarget = item[config["property"]]
      if (visitTarget) {
        const { url, options } = visitTarget
        Turbo.visit(url, options)
      }
    }
  }
}
