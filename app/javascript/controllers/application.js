import { Application } from "@hotwired/stimulus"

const application = Application.start()

// Configure Stimulus development experience
application.debug = false
window.Stimulus   = application

import StickyController from "./sticky_controller"
application.register("sticky", StickyController)

export { application }
