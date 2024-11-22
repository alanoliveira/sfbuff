import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="character-search-form"
export default class extends Controller {
  submit(e) {
    e.preventDefault()
    const data = this.formData()
    Turbo.visit(`/characters/${data.get("character")}/${data.get("control_type")}`)
  }

  formData() {
    return new FormData(this.element)
  }
}
