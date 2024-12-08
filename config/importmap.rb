# Pin npm packages by running ./bin/importmap

pin "application"
pin "@hotwired/turbo-rails", to: "turbo.min.js"
pin "@hotwired/stimulus", to: "stimulus.min.js"
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js"
pin "bootstrap", to: "https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.esm.min.js"
pin "@popperjs/core", to: "https://cdn.jsdelivr.net/npm/@popperjs/core@2.11.8/dist/esm/popper.min.js"
pin_all_from "app/javascript/controllers", under: "controllers"
pin "chartjs", to: "https://cdn.jsdelivr.net/npm/chart.js@4.4.7/+esm"
pin "chartjs/helpers", to: "https://cdn.jsdelivr.net/npm/chart.js@4.4.7/helpers/+esm"
pin_all_from "app/javascript/chartjs-plugins", under: "chartjs-plugins"
pin_all_from "app/javascript/helpers", under: "helpers"
