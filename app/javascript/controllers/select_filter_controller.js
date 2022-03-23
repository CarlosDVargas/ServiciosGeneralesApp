import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "employees" ]

  change(event) {
    fetch(this.data.get("url"), { 
      method: 'POST', 
      body: JSON.stringify( { value: [...document.getElementById("employees_status").children].map(option => option.value), status: [...document.getElementById("employees_status").children].map(option => option.checked)}),
      credentials: "include",
      dataType: 'script',
      headers: {
        "X-CSRF-Token": getMetaValue("csrf-token"),
        "Content-Type": "application/json"
      },
    })
      .then(response => response.text())
      .then(html => {
        this.employeesTarget.innerHTML = html
      })
  }
}

function getMetaValue(name) {
  const element = document.head.querySelector(`meta[name="${name}"]`)
  return element.getAttribute("content")
}