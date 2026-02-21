import { Controller } from "@hotwired/stimulus"
import { setCookie, getCookie } from "helpers/cookie_helpers"

// Connects to data-controller="timezone"
export default class extends Controller {
  connect() {
    const timezoneWasUndef = !getCookie("timezone")
    setCookie("timezone", Intl.DateTimeFormat().resolvedOptions().timeZone)
    if(timezoneWasUndef) {
      Turbo.visit(window.location)
    }
  }
}
