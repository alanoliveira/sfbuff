import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="language-select"
export default class extends Controller {
  connect() {
    this.element.addEventListener('change', this.change.bind(this))
  }

  change() {
    document.cookie = `locale=${this.element.value};path=/;SameSite=Strict`
    window.location = window.location
  }
}
