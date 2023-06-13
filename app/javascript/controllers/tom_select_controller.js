import { Controller } from "@hotwired/stimulus"
import TomSelect from "tom-select";

export default class extends Controller {
  static values = { options: Object }

  connect() {

    const optionsValue = this.optionsValue;

    if(optionsValue != "") {
      new TomSelect(
        this.element ,
        this.optionsValue
      );
    }
  }
}
