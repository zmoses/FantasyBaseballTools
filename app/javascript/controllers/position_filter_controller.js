import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["checkbox", "row"]

  filter() {
    const selectedPositions = this.checkboxTargets
      .filter(checkbox => checkbox.checked)
      .map(checkbox => checkbox.value)

    this.rowTargets.forEach(row => {
      const playerPositions = (row.dataset.positions || "").split(",").map(p => p.trim())
      const matches = selectedPositions.length === 0 || selectedPositions.some(pos => playerPositions.includes(pos))
      row.dataset.positionMatch = matches ? "true" : "false"
    })

    this.element.dispatchEvent(new CustomEvent("position-filter:change", { bubbles: true }))
  }
}
