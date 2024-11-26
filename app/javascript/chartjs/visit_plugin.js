export default {
  id: "visit",
  afterDraw: chart => {
    const config = chart.config.options.plugins.visit
    if(!config) { return }

    chart.options.onClick = evt => {
      const elements = chart.getElementsAtEventForMode(evt, 'nearest', { intersect: true })
      const target = elements[0] ? config.targets[elements[0].index] : null
      if (target) {
        const { url, options } = target
        Turbo.visit(url, options)
      }
    }
  }
}
