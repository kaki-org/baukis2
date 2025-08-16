// Rails 8 customer pack JavaScript entry point
import "@hotwired/turbo-rails"
import "./controllers"

// Action Cable for customer interface
import "./channels"

// Rails 8 optimization: Configure Turbo for customer interface
import { Turbo } from "@hotwired/turbo-rails"

// Customer-specific Turbo configuration
document.addEventListener("DOMContentLoaded", () => {
  // Customer interface specific initialization
  console.log("Customer interface loaded with Rails 8 Turbo")
})