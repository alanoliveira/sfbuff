import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="toast"
export default class extends Controller {
  initialize() {
    this.toast = new bootstrap.Toast(this.element)
    this.toast.show()
  }
}
