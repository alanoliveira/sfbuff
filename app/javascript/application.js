// Entry point for the build script in your package.json
import "@hotwired/turbo-rails"
import "./controllers"
import { setCookie } from "helpers/cookie_helpers"

setCookie('timezone', Intl.DateTimeFormat().resolvedOptions().timeZone)
