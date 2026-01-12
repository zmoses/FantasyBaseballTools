import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "row"]

  filter() {
    const query = this.comparableTerm(this.inputTarget.value)

    this.rowTargets.forEach(row => {
      const text = this.comparableTerm(row.textContent)

      if (text.includes(query)) {
        row.style.display = ""
      } else {
        row.style.display = "none"
      }
    })
  }

  comparableTerm(str) {
    return str.normalize('NFD').replace(/[\u0300-\u036f]/g, '').toLowerCase()
  }
}
