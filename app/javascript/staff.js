// Rails 8 staff pack JavaScript entry point
import "@hotwired/turbo-rails"
import "./controllers"

// Import staff-specific functionality
import "./staff/customer_form.js"

// Action Cable for staff interface
import "./channels"

// Rails 8 optimization: Configure Turbo for staff interface
import { Turbo } from "@hotwired/turbo-rails"

// Staff-specific Turbo configuration
document.addEventListener("DOMContentLoaded", () => {
  // Staff interface specific initialization
  console.log("Staff interface loaded with Rails 8 Turbo")
})
