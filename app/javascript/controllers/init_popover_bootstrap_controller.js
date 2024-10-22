import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="init-popover-bootstrap"
export default class extends Controller {
  initialize() {
    const popoverTriggerList = document.querySelectorAll('[data-bs-toggle="popover"]')
    const popoverList = [...popoverTriggerList].map(popoverTriggerEl => new bootstrap.Popover(popoverTriggerEl))
  }
}
