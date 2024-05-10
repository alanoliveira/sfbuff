import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = {
    time: String,
  }

  connect() {
    this.element.title = new Date(this.timeValue).toLocaleString();
  }
}
