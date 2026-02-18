import { Controller } from "@hotwired/stimulus"

// Toggle color theme between dark and light when the element is clicked.
export default class extends Controller {
  connect() {
    console.log('connected')
    document.documentElement.setAttribute('data-bs-theme', localStorage.getItem('theme'))
  }

  // Toggle color theme between dark and light when the element is clicked.
  toggle() {
    const oldTheme = localStorage.getItem('theme') || 'light'
    const newTheme = ((oldTheme == 'light') ? 'dark' : 'light')
    document.documentElement.setAttribute('data-bs-theme', newTheme)
    localStorage.setItem('theme', newTheme)
  }
}
