import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["content", "textarea", "indicator"]
  static values = { updateUrl: String, expanded: { type: Boolean, default: false } }

  toggle() {
    this.expandedValue = !this.expandedValue
    this.contentTarget.classList.toggle("hidden", !this.expandedValue)
    if (this.expandedValue) {
      this.textareaTarget.focus()
    }
  }

  save() {
    const notes = this.textareaTarget.value.trim()
    const csrfToken = document.querySelector('meta[name="csrf-token"]').content

    fetch(this.updateUrlValue, {
      method: "PATCH",
      headers: {
        "Content-Type": "application/json",
        "X-CSRF-Token": csrfToken,
        "Accept": "text/vnd.turbo-stream.html"
      },
      body: JSON.stringify({ notes: notes })
    })
    .then(response => {
      if (response.ok) {
        this.updateIndicator(notes.length > 0)
      }
    })
  }

  debouncedSave() {
    clearTimeout(this.saveTimeout)
    this.saveTimeout = setTimeout(() => this.save(), 500)
  }

  updateIndicator(hasNotes) {
    if (this.hasIndicatorTarget) {
      this.indicatorTarget.classList.toggle("text-amber-400", hasNotes)
      this.indicatorTarget.classList.toggle("text-slate-500", !hasNotes)
    }
  }
}
