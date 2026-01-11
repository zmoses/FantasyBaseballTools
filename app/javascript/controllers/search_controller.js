import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "row"]

  connect() {
    console.log("Search controller connected")
  }

  filter() {
    const query = this.inputTarget.value.toLowerCase()

    this.rowTargets.forEach(row => {
      const text = row.textContent.toLowerCase()

      if (text.includes(query)) {
        row.style.display = ""
      } else {
        row.style.display = "none"
      }
    })
  }
}
