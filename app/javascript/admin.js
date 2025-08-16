// Rails 8 admin pack JavaScript entry point
import "@hotwired/turbo-rails"
import "./controllers"

// Action Cable for admin interface
import "./channels"

// Rails 8 optimization: Configure Turbo for admin interface
import { Turbo } from "@hotwired/turbo-rails"

// Admin-specific Turbo configuration
document.addEventListener("DOMContentLoaded", () => {
  // Admin interface specific initialization
  console.log("Admin interface loaded with Rails 8 Turbo")
})