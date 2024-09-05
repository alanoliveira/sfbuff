import { Controller } from "@hotwired/stimulus"
import { Modal } from "bootstrap"

// Connects to data-controller="turbo-modal"
export default class extends Controller {
  connect() {
    this.modal = new Modal(this.element, { keyboard: false })
    this.element.addEventListener('hidden.bs.modal', this.hidden.bind(this))
    this.modal.show()
  }

  hidden() {
    this.modal.dispose()
  }
}
