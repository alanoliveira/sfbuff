// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"
import "bootstrap"
import LocalTime from "local-time"
import { ptBR, ja } from "local-time-i18n"

LocalTime.config.i18n["pt-BR"] = ptBR
LocalTime.config.i18n["ja"] = ja
LocalTime.config.locale = document.documentElement.lang
LocalTime.start()

document.addEventListener("turbo:morph", () => {
  LocalTime.run()
})
