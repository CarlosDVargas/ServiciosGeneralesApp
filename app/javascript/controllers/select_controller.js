import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
    static targets = ["select", "hidden", "field"];
    static classes = ["hidden"];

    connect() {
        var option = document.createElement("option");
        option.text = "Seleccione una opción";
        option.selected = true;
        option.disabled = true;
        this.selectTarget.add(option);
        this.hiddenTarget.classList.add(this.hiddenClass);
    }

    select() {
        let options = this.selectTarget
        let optionsAmount = options.length - 1;
        let lastOptionIndex = optionsAmount - 1;
        let lastOptionValue = options.options[lastOptionIndex].value;
        if (options.selectedIndex == lastOptionIndex) {
            this.hiddenTarget.classList.toggle(this.hiddenClass);
        } else {
            this.hiddenTarget.classList.add(this.hiddenClass);
        }
        if (lastOptionValue == 'other') {
            if (options.selectedIndex != lastOptionIndex) {
                this.fieldTarget.value = options.value;
            } else {
                this.fieldTarget.value = "";
            }
        }
    }

} 