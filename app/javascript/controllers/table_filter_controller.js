import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "elements" ]

  change(event) {
    fetch(this.data.get("url"), { 
      method: 'POST', 
      body: JSON.stringify( { filter: [...document.getElementById("filters").children].map(option => option.value), value: [...document.getElementById("filters").children].map(option => option.checked) }),
      credentials: "include",
      dataType: 'script',
      headers: {
        "X-CSRF-Token": getMetaValue("csrf-token"),
        "Content-Type": "application/json"
      },
    })
      .then(response => response.text())
      .then(html => {
        this.elementsTarget.innerHTML = html
      })
  }

  dateSelect(event) {
    fetch(this.data.get("url"), { 
      method: 'POST', 
      body: JSON.stringify( { date_start: [document.getElementById("date_start").value], date_end: [document.getElementById("date_end").value] }),
      credentials: "include",
      dataType: 'script',
      headers: {
        "X-CSRF-Token": getMetaValue("csrf-token"),
        "Content-Type": "application/json"
      },
    })
      .then(response => response.text())
      .then(html => {
        this.elementsTarget.innerHTML = html
      })
  }
}

function getMetaValue(name) {
  const element = document.head.querySelector(`meta[name="${name}"]`)
  return element.getAttribute("content")
}