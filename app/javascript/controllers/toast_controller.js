import { Controller } from "@hotwired/stimulus"
import { Toast } from "bootstrap"

// Connects to data-controller="toast"
export default class extends Controller {
  initialize() {
    this.toast = new Toast(this.element)
    this.toast.show()
  }
}
