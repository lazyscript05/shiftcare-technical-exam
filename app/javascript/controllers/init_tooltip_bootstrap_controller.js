import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="init-tooltip-bootstrap"
export default class extends Controller {
  initialize() {
    const tooltipTriggerList = document.querySelectorAll('[data-bs-toggle="tooltip"]')
    const tooltipList = [...tooltipTriggerList].map(tooltipTriggerEl => new bootstrap.Tooltip(tooltipTriggerEl))
  }
}
