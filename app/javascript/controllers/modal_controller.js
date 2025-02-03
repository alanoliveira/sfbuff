import { Controller } from "@hotwired/stimulus"
import "bootstrap"

// Connects to data-controller="modal"
export default class extends Controller {
  initialize() {
    this.modal = new bootstrap.Modal(this.element)
    this.element.addEventListener("hidden.bs.modal", this.#hidden.bind(this))
  }

  connect() {
    this.modal.show()
  }

  disconnect() {
    this.modal.dispose()
  }

  #hidden() {
    this.element.remove()
  }
}
