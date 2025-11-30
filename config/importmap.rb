# Pin npm packages by running ./bin/importmap

pin "application"
pin "@hotwired/turbo-rails", to: "turbo.min.js"
pin "@hotwired/stimulus", to: "stimulus.min.js"
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js"
pin_all_from "app/javascript/controllers", under: "controllers"
pin_all_from "app/javascript/chartjs/plugins", under: "chartjs-plugins", to: "chartjs/plugins"
pin_all_from "app/javascript/helpers", under: "helpers"
pin_all_from "app/javascript/local-time-i18n", under: "local-time-i18n"

pin "bootstrap", to: "/assets/bootstrap/dist/js/bootstrap.bundle.min.js"
pin "local-time", to: "/assets/local-time/app/assets/javascripts/local-time.es2017-esm.js"
pin "chartjs", to: "/assets/chart.js/dist/chart.umd.js"
pin "chartjs-adapter-date-fns", to: "/assets/chartjs-adapter-date-fns/dist/chartjs-adapter-date-fns.bundle.min.js"
pin "date-fns/locale/pt-BR", to: "/assets/date-fns/locale/pt-BR.js"
pin "date-fns/locale/ja", to: "/assets/date-fns/locale/ja.js"
