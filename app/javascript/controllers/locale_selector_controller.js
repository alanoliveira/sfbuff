import { Controller } from "@hotwired/stimulus"
import { setCookie } from "helpers/cookie_helpers"

// Connects to data-controller="locale-selector"
export default class extends Controller {
  connect() {
  }

  switchLocale(evt) {
    setCookie("locale", evt.params.locale)
    location.reload()
  }
}
