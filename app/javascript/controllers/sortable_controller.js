import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="sortable"
export default class extends Controller {
  static targets = ["header", "body"]
  static values = { currentColumn: Number, ascending: Boolean }

  connect() {
    this.currentColumnValue = 1 // ESPN Rank column
    this.ascendingValue = true

    // Apply default highlight to ESPN Rank header
    const defaultHeader = this.headerTargets.find(h => h.dataset.columnIndex === "1")
    if (defaultHeader) {
      this.updateHeaderIndicators(defaultHeader)
    }
  }

  sort(event) {
    const header = event.currentTarget
    const columnIndex = parseInt(header.dataset.columnIndex)

    if (this.currentColumnValue === columnIndex) {
      this.ascendingValue = !this.ascendingValue
    } else {
      this.currentColumnValue = columnIndex
      this.ascendingValue = true
    }

    this.updateHeaderIndicators(header)
    this.sortTable(columnIndex)
  }

  updateHeaderIndicators(activeHeader) {
    this.headerTargets.forEach(header => {
      // Reset header background
      header.classList.remove("bg-slate-500")
      header.classList.add("bg-slate-600")

      const icon = header.querySelector("svg")
      if (icon) {
        icon.classList.remove("rotate-180")
        icon.classList.remove("text-white")
        icon.classList.add("text-slate-400")
      }
    })

    // Highlight active header
    activeHeader.classList.remove("bg-slate-600")
    activeHeader.classList.add("bg-slate-500")

    const activeIcon = activeHeader.querySelector("svg")
    if (activeIcon) {
      activeIcon.classList.remove("text-slate-400")
      activeIcon.classList.add("text-white")
      if (!this.ascendingValue) {
        activeIcon.classList.add("rotate-180")
      }
    }
  }

  sortTable(columnIndex) {
    const rows = Array.from(this.bodyTarget.querySelectorAll("tr"))

    rows.sort((a, b) => {
      const aCell = a.querySelectorAll("td")[columnIndex]
      const bCell = b.querySelectorAll("td")[columnIndex]

      const aValue = parseInt(aCell?.textContent?.trim()) || 999
      const bValue = parseInt(bCell?.textContent?.trim()) || 999

      return this.ascendingValue ? aValue - bValue : bValue - aValue
    })

    rows.forEach(row => this.bodyTarget.appendChild(row))
  }
}
