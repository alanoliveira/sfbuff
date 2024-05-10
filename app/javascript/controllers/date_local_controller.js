import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["hidden", "input"]

  connect() {
    this.hiddenToInput()
    this.inputTarget.addEventListener('change', this.inputToHidden.bind(this))
  }

  hiddenToInput() {
    let date = new Date(this.hiddenTarget.value);
    if (isNaN(date)) {
      return
    }
    this.inputTarget.value = date.toISOString().substring(0, 10);
  }

  inputToHidden() {
    let date = this.inputTarget.valueAsDate;
    this.hiddenTarget.value = date.toISOString()
  }
}
