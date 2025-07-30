# Pin npm packages by running ./bin/importmap

pin "application"
pin "@hotwired/turbo-rails", to: "turbo.min.js"
pin "@hotwired/stimulus", to: "stimulus.min.js"
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js"

pin "bootstrap", to: "https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"
pin "chartjs", to: "https://cdn.jsdelivr.net/npm/chart.js@4.5.0/dist/chart.umd.min.js"
pin "date-fns", to: "https://cdn.jsdelivr.net/npm/date-fns@4.1.0/cdn.min.js"
pin "chartjs-adapter-date-fns", to: "https://cdn.jsdelivr.net/npm/chartjs-adapter-date-fns@3.0.0/dist/chartjs-adapter-date-fns.bundle.min.js"
pin "date-fns/locale/ja", to: "https://cdn.jsdelivr.net/npm/date-fns@4.1.0/locale/ja/+esm"
pin "date-fns/locale/pt-BR", to: "https://cdn.jsdelivr.net/npm/date-fns@4.1.0/locale/pt-BR/+esm"
pin "chartjs-plugin-zoom", to: "https://cdn.jsdelivr.net/npm/chartjs-plugin-zoom@2.2.0/dist/chartjs-plugin-zoom.min.js"
pin "local-time", to: "https://cdn.jsdelivr.net/npm/local-time@3.0.2/+esm"

pin_all_from "app/javascript/helpers", under: "helpers"
pin_all_from "app/javascript/controllers", under: "controllers"
pin_all_from "app/javascript/chartjs-plugins", under: "chartjs-plugins"
