import { Controller } from "@hotwired/stimulus"
import { Modal } from "bootstrap"

// Connects to data-controller="turbo-modal"
export default class extends Controller {
  static targets = ["content", "spinner"]

  connect() {
    this.modal = new Modal(this.element, { keyboard: false })
    this.element.addEventListener('turbo:before-fetch-request', this.show.bind(this))
    this.element.addEventListener('turbo:frame-load', this.load.bind(this))
  }

  show() {
    this.contentTarget.classList.add("d-none")
    this.spinnerTarget.classList.remove("d-none")
    this.modal.show()
  }

  load() {
    this.spinnerTarget.classList.add("d-none")
    this.contentTarget.classList.remove("d-none")
  }
}
