// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"
import { setCookie, getCookie } from "helpers/cookie_helpers"

if(!getCookie("timezone")) {
  setCookie("timezone", Intl.DateTimeFormat().resolvedOptions().timeZone)
  Turbo.visit(window.location)
}
