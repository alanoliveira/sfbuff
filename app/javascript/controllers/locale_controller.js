import { Controller } from "@hotwired/stimulus"
import { setCookie, getCookie } from "helpers/cookie_helpers"

// Connects to data-controller="locale"
export default class extends Controller {
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
}
