import { Controller } from "@hotwired/stimulus"
import { Modal } from "bootstrap"

// Connects to data-controller="battle-modal"
export default class extends Controller {
  connect() {
    this.modal = new Modal(this.element, { keyboard: false })
    this.element.addEventListener('turbo:frame-load', this.frameLoad.bind(this))
  }

  disconnect() {
    this.modal.hide()
  }

  frameLoad() {
    this.modal.show()
  }
}
