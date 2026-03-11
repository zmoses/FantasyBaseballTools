import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["panel", "list", "row"]

  fetch(event) {
    event.preventDefault()
    const form = event.target
    const token = document.querySelector('meta[name="csrf-token"]').content
    fetch(form.action, {
      method: "POST",
      headers: { "X-CSRF-Token": token, "Accept": "application/json" }
    })
      .then(r => r.json())
      .then(recommendations => this.showRecommendations(recommendations))
  }

  showRecommendations(recommendations) {
    this.clearHighlights()
    recommendations.forEach(rec => {
      const row = this.rowTargets.find(r => r.dataset.playerName === rec.name)
      if (row) row.classList.add("ring-2", "ring-inset", "ring-amber-400", "bg-amber-900/20")
    })
    this.listTarget.innerHTML = recommendations.map(rec => `
      <div class="p-4 border-b border-slate-700 last:border-0">
        <p class="text-sm font-semibold text-amber-400">${rec.name} <span class="text-slate-400 font-normal text-xs">${rec.position}</span></p>
        <p class="text-xs text-slate-400 mt-1">${rec.reasoning}</p>
      </div>
    `).join("")
    this.panelTarget.classList.remove("hidden")
  }

  close() {
    this.panelTarget.classList.add("hidden")
    this.clearHighlights()
  }

  clearHighlights() {
    this.rowTargets.forEach(row => {
      row.classList.remove("ring-2", "ring-inset", "ring-amber-400", "bg-amber-900/20")
    })
  }
}
