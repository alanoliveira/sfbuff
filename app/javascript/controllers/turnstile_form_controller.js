import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="turnstile-form"
export default class extends Controller {
  static targets = ["widget"]
  static values = {
    sitekey: String
  }

  connect() {
    document.addEventListener("turbo:load", this.#turboLoad.bind(this), { once: true })
  }

  #turboLoad() {
    turnstile.render(this.widgetTarget, {
      sitekey: this.sitekeyValue,
      callback: this.#onSuccess.bind(this)
    })
  }

  #onSuccess() {
    this.element.requestSubmit()
  }
}
