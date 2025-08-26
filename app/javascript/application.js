// Rails 8 application JavaScript entry point
// Configure Turbo for Rails 8 compatibility
import "@hotwired/turbo-rails"

// Import and configure Stimulus for Rails 8
import { Application } from "@hotwired/stimulus"
import { definitionsFromContext } from "@hotwired/stimulus-webpack-helpers"

// Start Stimulus application
const application = Application.start()

// Load Stimulus controllers using webpack helpers
const context = require.context("./controllers", true, /\.js$/)
application.load(definitionsFromContext(context))

// Configure Turbo for Rails 8 optimizations
import { Turbo } from "@hotwired/turbo-rails"
Turbo.session.drive = true

// Action Cable for WebSocket functionality
import "./channels"

// Rails 8 compatibility: Configure Turbo Drive for better performance
document.addEventListener("turbo:before-cache", () => {
  // Clean up any temporary UI states before caching
})

// Rails 8 enhancement: Better error handling for Turbo
document.addEventListener("turbo:frame-missing", (event) => {
  console.warn("Turbo frame missing:", event.detail.fetchResponse.url)
})
