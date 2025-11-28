import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="auto-submit"
export default class extends Controller {
  static values = {
    wait: { type: Number, default: 0 }
  }

  initialize() {
    setTimeout(this.submit.bind(this), this.waitValue)
  }

  submit() {
    this.element.requestSubmit()
  }
}
