import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="auto-click"
export default class extends Controller {
  connect() {
    this.element.click()
  }
}
