import { Controller } from "@hotwired/stimulus"
import { setCookie } from "helpers/cookie_helpers"

// Connects to data-controller="locale-switch"
export default class extends Controller {
  connect() {
    this.element.querySelectorAll("ul li button").forEach(btn => btn.addEventListener("click", this.changeLocale.bind(this)))
  }

  changeLocale(evt) {
    setCookie("locale", evt.target.value)
    location.reload()
  }
}
