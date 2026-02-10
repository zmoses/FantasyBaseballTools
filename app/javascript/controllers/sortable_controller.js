import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="sortable"
// Alt+click (Option+click on Mac) on CBS/Fantasy Pros columns to sort by difference from ESPN rank
export default class extends Controller {
  static targets = ["header", "body"]
  static values = { currentColumn: Number, ascending: Boolean, diffMode: Boolean }

  connect() {
    this.currentColumnValue = 1 // ESPN Rank column
    this.ascendingValue = true
    this.diffModeValue = false

    // Apply default highlight to ESPN Rank header
    const defaultHeader = this.headerTargets.find(h => h.dataset.columnIndex === "1")
    if (defaultHeader) {
      this.updateHeaderIndicators(defaultHeader)
    }
  }

  sort(event) {
    const header = event.currentTarget
    const columnIndex = parseInt(header.dataset.columnIndex)
    const supportsDiff = header.dataset.supportsDiff === "true"
    const requestedDiffMode = event.altKey && supportsDiff

    if (this.currentColumnValue === columnIndex && this.diffModeValue === requestedDiffMode) {
      // Same column and same mode - toggle direction
      this.ascendingValue = !this.ascendingValue
    } else {
      // Different column or different mode - reset to ascending
      this.currentColumnValue = columnIndex
      this.diffModeValue = requestedDiffMode
      this.ascendingValue = true
    }

    this.updateHeaderIndicators(header)
    this.sortTable(columnIndex)
  }

  updateHeaderIndicators(activeHeader) {
    this.headerTargets.forEach(header => {
      // Reset header background
      header.classList.remove("bg-slate-500", "bg-amber-700")
      header.classList.add("bg-slate-600")

      const icon = header.querySelector("svg")
      if (icon) {
        icon.classList.remove("rotate-180")
        icon.classList.remove("text-white")
        icon.classList.add("text-slate-400")
      }
    })

    // Highlight active header (amber for diff mode, slate for normal)
    activeHeader.classList.remove("bg-slate-600")
    if (this.diffModeValue) {
      activeHeader.classList.add("bg-amber-700")
    } else {
      activeHeader.classList.add("bg-slate-500")
    }

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
    const espnColumnIndex = 1

    rows.sort((a, b) => {
      const aCells = a.querySelectorAll("td")
      const bCells = b.querySelectorAll("td")

      let aValue, bValue

      if (this.diffModeValue) {
        // Sort by difference from ESPN rank
        const aEspn = parseInt(aCells[espnColumnIndex]?.textContent?.trim()) || 999
        const bEspn = parseInt(bCells[espnColumnIndex]?.textContent?.trim()) || 999
        const aRank = parseInt(aCells[columnIndex]?.textContent?.trim()) || 999
        const bRank = parseInt(bCells[columnIndex]?.textContent?.trim()) || 999

        // Difference: negative means this source ranks them higher (better) than ESPN
        aValue = aRank - aEspn
        bValue = bRank - bEspn
      } else {
        // Sort by raw rank value
        aValue = parseInt(aCells[columnIndex]?.textContent?.trim()) || 999
        bValue = parseInt(bCells[columnIndex]?.textContent?.trim()) || 999
      }

      return this.ascendingValue ? aValue - bValue : bValue - aValue
    })

    rows.forEach(row => this.bodyTarget.appendChild(row))
  }
}
