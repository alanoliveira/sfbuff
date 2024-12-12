import { Controller } from "@hotwired/stimulus"
import { setCookie, getCookie } from "helpers/cookie_helpers"
import LocalTime from "local-time"
import localTimeI18n from "helpers/local-time-i18n"

for (const [key, value] of Object.entries(localTimeI18n)) {
  LocalTime.config.i18n[key] = value
}

// Connects to data-controller="locale"
export default class extends Controller {
  connect() {
    LocalTime.config.locale = this.getLocale()
    LocalTime.start()
  }

  updateLocale(event) {
    this.setLocale(event.target.value)
  }

  setLocale(locale) {
    setCookie('locale', locale)
    window.location.reload()
  }

  getLocale() {
    return getCookie('locale') || "en"
  }
}
