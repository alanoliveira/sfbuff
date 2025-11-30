export default {
  id: "tiptool",
  beforeInit: chart => {
    chart.config.options.plugins.tooltip = Chart.helpers.merge(chart.config.options.plugins.tooltip, {
      callbacks: {
        title: ctxs => ctxs[0].raw.title || ctxs[0].title,
        label: ctx => ctx.raw.label || ctx.formattedValue
      }
    })
  }
}
