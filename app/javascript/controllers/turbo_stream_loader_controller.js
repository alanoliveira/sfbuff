import { Controller } from "@hotwired/stimulus"
import { get } from "@rails/request.js"

const ACCEPTED_STATUS = 202

// Connects to data-controller="turbo-stream-loader"
export default class extends Controller {

  #attempt = 0

  static values = {
    url: String,
    interval: { type: Number, default: 3000 },
    maxAtempts: { type: Number, default: 30 },
  }

  connect() {
    this.intervalId = setInterval(this.#loadTurboStream.bind(this), this.intervalValue)
  }

  disconnect() {
    clearInterval(this.intervalId)
  }

  async #loadTurboStream() {
    this.#attempt += 1

    const { response } = await get(this.urlValue, { responseKind: "turbo-stream" })
    if(response.status != ACCEPTED_STATUS || this.#attempt >= this.maxAtemptsValue) {
      clearInterval(this.intervalId)
    }
  }
}
