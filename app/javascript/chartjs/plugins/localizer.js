import ja from "date-fns/locale/ja";
import ptBR from "date-fns/locale/pt-BR";

const DATE_FNS_LOCALES = { ja, "pt-BR": ptBR }

export default {
  id: "localizer",
  beforeLayout: chart => {
    const config = chart.config.options.plugins.localize
    if (!config) { return }

    Object.entries(chart.scales).forEach(([scale_name, scale]) => {
      scale.options = Chart.helpers.merge(scale.options, {
        adapters: {
          date: {
            locale: DATE_FNS_LOCALES[config.locale]
          }
        }
      })
    })
  }
}
