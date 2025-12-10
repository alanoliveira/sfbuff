import { Controller } from "@hotwired/stimulus"
import { setCookie } from "helpers/cookie_helpers"

// Connects to data-controller="fair-use"
export default class extends Controller {
  agree() {
    setCookie("fair_use_agreement", true)
    bootstrap.Modal.getInstance(this.element).hide()
  }

  disagree() {
    location = "/"
  }
}
