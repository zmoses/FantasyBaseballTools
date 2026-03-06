import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "row"]

  connect() {
    this.element.addEventListener("position-filter:change", () => this.filter())
  }

  filter() {
    const query = this.comparableTerm(this.inputTarget.value)

    this.rowTargets.forEach(row => {
      const text = this.comparableTerm(row.textContent)
      const matchesSearch = text.includes(query)
      const matchesPosition = row.dataset.positionMatch !== "false"

      if (matchesSearch && matchesPosition) {
        row.classList.remove("hidden")
      } else {
        row.classList.add("hidden")
      }
    })
  }

  clear() {
    this.inputTarget.value = ""
    this.filter()
  }

  comparableTerm(str) {
    return str.normalize('NFD').replace(/[\u0300-\u036f]/g, '').toLowerCase()
  }
}
