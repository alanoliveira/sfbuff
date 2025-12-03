import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="theme-selector"
export default class extends Controller {
  static targets = [ "option" ]

  connect() {
    this.#updateTheme()
  }

  get theme() {
    return localStorage.getItem("theme")
  }

  set theme(value) {
    localStorage.setItem("theme", value)
  }

  switchTheme(evt) {
    this.theme = evt.params.theme
    this.#updateTheme()
  }

  #updateTheme() {
    this.#applyTheme()
    this.#highlightSelectedOption()
  }

  #applyTheme() {
    const theme = this.theme
    if (theme === "dark" || theme === "light") {
      document.documentElement.setAttribute("data-bs-theme", theme)
    } else {
      document.documentElement.setAttribute("data-bs-theme", (window.matchMedia("(prefers-color-scheme: dark)").matches ? "dark" : "light"))
    }
  }

  #highlightSelectedOption() {
    const theme = this.theme
    this.optionTargets.forEach(option => {
      option.classList.toggle("active", option.dataset.themeSelectorThemeParam == theme)
    })
  }
}
