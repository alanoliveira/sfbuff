# Pin npm packages by running ./bin/importmap

pin "application"
pin "@hotwired/turbo-rails", to: "turbo.min.js"
pin "@hotwired/stimulus", to: "stimulus.min.js"
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js"

pin "bootstrap", to: "https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"
pin "chartjs", to: "https://cdn.jsdelivr.net/npm/chart.js@4.4.7/dist/chart.umd.min.js"
pin "local-time", to: "https://cdn.jsdelivr.net/npm/local-time@3.0.2/+esm"

pin_all_from "app/javascript/helpers", under: "helpers"
pin_all_from "app/javascript/controllers", under: "controllers"
pin_all_from "app/javascript/chartjs-plugins", under: "chartjs-plugins"
