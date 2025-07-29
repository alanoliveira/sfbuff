export default {
  id: "visit",
  afterDraw: chart => {
    const config = chart.config.options.plugins.visit
    if (!config) { return }

    chart.options.onClick = evt => {
      const elements = chart.getElementsAtEventForMode(evt, 'nearest', { intersect: true })
      const firstPoint = elements[0]
      if (!firstPoint) return
      const baseUrl = config.baseUrl

      const item = chart.data.datasets[firstPoint.datasetIndex].data[firstPoint.index];
      const visitTarget = item[config["property"]]
      if (visitTarget) {
        const { url, path, options } = visitTarget
        if(baseUrl) {
          Turbo.visit(baseUrl + path, options)
        } else{
          Turbo.visit(url, options)
        }
      }
    }
  }
}
