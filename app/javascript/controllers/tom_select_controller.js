import { Controller } from "@hotwired/stimulus"
import TomSelect from "tom-select";

export default class extends Controller {
  static values = { options: Object }

  connect() {

    const optionsValue = this.optionsValue;

    if(optionsValue != "") {
      const select = new TomSelect(
        this.element ,
        this.optionsValue
      );
      select.on("change", () => {
        select.setTextboxValue("");
      });
    }
  }
}
