import { Controller } from "@hotwired/stimulus"
import { Modal } from "bootstrap"

// Connects to data-controller="turbo-modal"
export default class extends Controller {
  static targets = ["content"]

  connect() {
    this.modal = new Modal(this.element, { keyboard: false })
    this.element.addEventListener('turbo:before-frame-render', this.load.bind(this))
  }

  disconnect() {
    this.modal.hide()
  }

  load() {
    this.modal.show()
  }
}
