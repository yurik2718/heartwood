import { Controller } from "@hotwired/stimulus"

// Slide-over panel over the tree canvas. A node link loads people#panel into the
// frame; the drawer opens when the frame finishes loading and closes on the ✕
// button or Escape. Closing also empties the frame so re-clicking the same
// person triggers a fresh load (a frame keeps its src otherwise).
export default class extends Controller {
  static targets = ["frame"]

  connect() {
    this._onLoad = () => this.open()
    this.frameTarget.addEventListener("turbo:frame-load", this._onLoad)
  }

  disconnect() {
    this.frameTarget.removeEventListener("turbo:frame-load", this._onLoad)
  }

  open() {
    this.element.classList.add("tree-drawer--open")
  }

  close() {
    this.element.classList.remove("tree-drawer--open")
    this.frameTarget.removeAttribute("src")
    this.frameTarget.innerHTML = ""
  }
}
