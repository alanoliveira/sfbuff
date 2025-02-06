import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="form-helper"
export default class extends Controller {
  static values = {
    compactBlank: { type: Boolean, default: false }
  }

  connect() {
    if (this.compactBlankValue) {
      this.element.addEventListener("turbo:before-fetch-request", this.#compactBlank)
    }
  }

  #compactBlank(evt) {
    let searchParams = evt.detail.url.searchParams
    let cleanKeys = []
    for (const [key, value] of searchParams.entries()) {
      if (value == "") { cleanKeys.push(key) }
    }
    cleanKeys.forEach(k => searchParams.delete(k))
  }
}
