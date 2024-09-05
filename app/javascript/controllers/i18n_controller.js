import { Controller } from "@hotwired/stimulus"
import { getCookie, setCookie } from "../helpers/cookie_helpers"

// Connects to data-controller="i18n"
export default class extends Controller {
  connect() {
    this.setTimezone(this.defaultTimezone())
  }

  updateLocale(event) {
    this.setLocale(event.target.value)
  }

  setLocale(locale) {
    setCookie('locale', locale)
    window.location.reload()
  }

  getLocale() {
    return getCookie('locale')
  }

  setTimezone(timezone) {
    setCookie('timezone', timezone)
  }

  getTimezone() {
    return getCookie('timezone')
  }

  defaultTimezone() {
    return Intl.DateTimeFormat().resolvedOptions().timeZone
  }
}
