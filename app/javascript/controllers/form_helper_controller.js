import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="form-helper"
export default class extends Controller {
  compactBlank(evt) {
    let searchParams = evt.detail.url.searchParams
    let cleanKeys = []
    for (const [key, value] of searchParams.entries()) {
      if (value == "") { cleanKeys.push(key) }
    }
    cleanKeys.forEach(k => searchParams.delete(k))
  }
}
