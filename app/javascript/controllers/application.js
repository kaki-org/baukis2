// Rails 8 Stimulus application configuration
import { Application } from "@hotwired/stimulus"

const application = Application.start()

// Configure Stimulus development experience for Rails 8
application.debug = false
document.documentElement.setAttribute("data-controller", "application")

export { application }