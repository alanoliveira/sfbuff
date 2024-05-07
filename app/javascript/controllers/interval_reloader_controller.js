import { Controller } from "@hotwired/stimulus"
import { get } from "@rails/request.js"

export default class extends Controller {
  static values = {
    delay: { type: Number, default: 5000 },
    url: { type: String },
  }

  connect() {
    this.timeout = setInterval(this.reload_page.bind(this), this.delayValue)
  }

  disconnect() {
    clearInterval(this.timeout)
  }

  reload_page() {
    get(this.urlValue, { responseKind: 'turbo-stream' })
  }
}
