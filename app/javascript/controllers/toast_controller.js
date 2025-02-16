import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="toast"
export default class extends Controller {
  static values = {
    wait: { type: Number, default: 0 }
  }

  initialize() {
    this.toast = new bootstrap.Toast(this.element)
    setTimeout(this.show.bind(this), this.waitValue)
  }

  show() {
    this.toast.show()
  }
}
