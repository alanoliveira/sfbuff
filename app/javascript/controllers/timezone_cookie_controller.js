import { Controller } from "@hotwired/stimulus"
import { setCookie, getCookie } from "helpers/cookie_helpers"

// Connects to data-controller="timezone-cookie"
export default class extends Controller {
  static TZ_COOKIE_NAME = "timezone"

  static values = {
    timezone: String
  }

  connect() {
    if (!this.getTzCookie()) {
      this.setTzCookie(this.getDefaultTimeZone())
    }
  }

  getDefaultTimeZone() {
    return Intl.DateTimeFormat().resolvedOptions().timeZone
  }

  getTzCookie() {
    return getCookie(this.constructor.TZ_COOKIE_NAME)
  }

  setTzCookie(value) {
    setCookie(this.constructor.TZ_COOKIE_NAME, value)
  }
}
