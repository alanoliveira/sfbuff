import { Controller } from "@hotwired/stimulus"
import { setCookie } from "helpers/cookie_helpers"

// Connects to data-controller="language-select"
export default class extends Controller {
  connect() {
    this.element.addEventListener('change', this.change.bind(this))
  }

  change() {
    setCookie('locale', this.element.value)
    window.location = window.location
  }
}
