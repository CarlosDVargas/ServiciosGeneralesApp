import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    console.log("Connecting")
    //this.element.textContent = "Hello World!"
  }

  handleChange() {
    console.log("Changing")
  }
}
