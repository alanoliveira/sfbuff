import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="color-mode"
export default class extends Controller {
  static targets = ["buttons"]

  connect() {
    this.applyPreferredMode()
  }

  dark() { this.changeMode('dark') }
  light() { this.changeMode('light') }
  auto() { this.changeMode('auto') }

  changeMode(mode) {
    this.setStoredMode(mode)
    this.applyPreferredMode()
  }

  applyPreferredMode() {
    this.applyMode(this.getPreferredMode())
  }

  applyMode(mode) {
    const scheme = mode == 'auto' ? this.getAutoMode() : mode
    this.element.setAttribute('data-bs-theme', scheme)
    this.buttonsTargets.forEach(b => {
      b.classList.toggle("active", b.value == mode)
    })
  }

  getPreferredMode() {
    const storedMode = this.getStoredMode()
    if (storedMode) {
      return storedMode
    }
    return 'auto'
  }

  getAutoMode() {
    return window.matchMedia('(prefers-color-scheme: dark)').matches ? 'dark' : 'light'
  }

  getStoredMode() {
    return localStorage.getItem('mode')
  }

  setStoredMode(mode) {
    localStorage.setItem('mode', mode)
  }
}
