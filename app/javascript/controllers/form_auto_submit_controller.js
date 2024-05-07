import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    // without this timeout Turbo can't do it's internal preparation
    // as side effect the loading bar is stalled forever
    // TODO: research what is going on
    this.timeout = setTimeout(() => this.element.requestSubmit(), 500)
  }

  disconnect() {
    clearTimeout(this.timeout)
  }
}

