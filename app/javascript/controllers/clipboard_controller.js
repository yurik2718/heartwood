import { Controller } from "@hotwired/stimulus"

// Copies a target field's value to the clipboard — used on the invite-link box.
export default class extends Controller {
  static targets = ["source"]

  async copy() {
    await navigator.clipboard.writeText(this.sourceTarget.value ?? this.sourceTarget.textContent)
  }
}
