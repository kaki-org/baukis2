// Rails 8 Stimulus controller for customer form functionality
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["homeAddressCheckbox", "workAddressCheckbox", "homeAddressFields", "workAddressFields"]

  connect() {
    this.toggleHomeAddressFields()
    this.toggleWorkAddressFields()
  }

  toggleHomeAddress() {
    this.toggleHomeAddressFields()
  }

  toggleWorkAddress() {
    this.toggleWorkAddressFields()
  }

  toggleHomeAddressFields() {
    const checked = this.homeAddressCheckboxTarget.checked
    const fields = this.homeAddressFieldsTarget
    
    fields.querySelectorAll("input, select").forEach(element => {
      element.disabled = !checked
    })
    
    if (checked) {
      fields.style.display = "block"
    } else {
      fields.style.display = "none"
    }
  }

  toggleWorkAddressFields() {
    const checked = this.workAddressCheckboxTarget.checked
    const fields = this.workAddressFieldsTarget
    
    fields.querySelectorAll("input, select").forEach(element => {
      element.disabled = !checked
    })
    
    if (checked) {
      fields.style.display = "block"
    } else {
      fields.style.display = "none"
    }
  }
}