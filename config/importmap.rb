# Pin npm packages by running ./bin/importmap

pin "application"
pin "@hotwired/turbo-rails", to: "turbo.min.js"
pin "@hotwired/stimulus", to: "stimulus.min.js"
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js"
pin_all_from "app/javascript/controllers", under: "controllers"

pin "bootstrap", to: "/assets/bootstrap/dist/js/bootstrap.bundle.min.js"
pin "local-time", to: "/assets/local-time/app/assets/javascripts/local-time.es2017-esm.js"
pin "chartjs", to: "/assets/chart.js/dist/chart.umd.js"
