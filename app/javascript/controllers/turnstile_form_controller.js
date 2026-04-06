import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="turnstile-form"
export default class extends Controller {
  static targets = ["widget"]
  static values = {
    sitekey: String
  }

  connect() {
    const intervalId = setInterval(() => {
      if(!window.turnstile)
        return;

      clearInterval(intervalId)
      turnstile.render(this.widgetTarget, {
        sitekey: this.sitekeyValue,
        callback: this.#onSuccess.bind(this)
      })
    }, 400)
  }

  #onSuccess() {
    this.element.requestSubmit()
  }
}
