# Pin npm packages by running ./bin/importmap

pin "application"
pin "@hotwired/turbo-rails", to: "turbo.min.js"
pin "@hotwired/stimulus", to: "stimulus.min.js"
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js"
pin_all_from "app/javascript/controllers", under: "controllers"
pin_all_from "app/javascript/chartjs/plugins", under: "chartjs-plugins", to: "chartjs/plugins"
pin_all_from "app/javascript/helpers", under: "helpers"
pin_all_from "app/javascript/local-time-i18n", under: "local-time-i18n"

if ENV["SFBUFF_USE_LOCAL_ASSETS"]
  pin "bootstrap", to: "/assets/bootstrap/dist/js/bootstrap.bundle.min.js"
  pin "local-time", to: "/assets/local-time/app/assets/javascripts/local-time.es2017-esm.js"
  pin "chartjs", to: "/assets/chart.js/dist/chart.umd.js"
  pin "chartjs-adapter-date-fns", to: "/assets/chartjs-adapter-date-fns/dist/chartjs-adapter-date-fns.bundle.min.js"
  pin "date-fns/locale/pt-BR", to: "/assets/date-fns/locale/pt-BR.js"
  pin "date-fns/locale/ja", to: "/assets/date-fns/locale/ja.js"
  pin "@rails/request.js", to: "/assets/@rails/request.js/dist/requestjs.min.js"
else
  pin "bootstrap", to: "https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/js/bootstrap.bundle.min.js"
  pin "local-time", to: "https://cdn.jsdelivr.net/npm/local-time@3.0.3/app/assets/javascripts/local-time.es2017-esm.js"
  pin "chartjs", to: "https://cdn.jsdelivr.net/npm/chart.js@4.5.1/dist/chart.umd.js"
  pin "chartjs-adapter-date-fns", to: "https://cdn.jsdelivr.net/npm/chartjs-adapter-date-fns@3.0.0/dist/chartjs-adapter-date-fns.bundle.min.js"
  pin "date-fns/locale/pt-BR", to: "https://cdn.jsdelivr.net/npm/date-fns@4.1.0/locale/pt-BR.js"
  pin "date-fns/locale/ja", to: "https://cdn.jsdelivr.net/npm/date-fns@4.1.0/locale/ja.js"
  pin "@rails/request.js", to: "https://cdn.jsdelivr.net/npm/@rails/request.js@0.0.13/dist/requestjs.min.js"
end
