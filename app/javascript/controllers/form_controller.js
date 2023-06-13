import { Controller } from "@hotwired/stimulus"
import { Country, State, City }  from 'country-state-city';


export default class extends Controller {
  static targets = ["stateSelect", "citySelect"];

  connect() {
    console.log("hello from form controller");
  }

  updateStates(event) {
    const countryId = event.target.value;
    const states = State.getStatesOfCountry(countryId);

    this.stateSelectTarget.innerHTML = '';

    states.forEach((state) => {
      const option = document.createElement("option");
      option.value = state.isoCode;
      option.text = state.name;
      option.setAttribute('data-country-code', countryId);
      this.stateSelectTarget.appendChild(option);
    });
  }


  updateCities(event) {
    const stateId = event.target.value;
    const countryId = event.target.options[event.target.selectedIndex].getAttribute('data-country-code');
    const state = State.getStateByCodeAndCountry(stateId, countryId);
    const cities = City.getCitiesOfState(state.countryCode, state.isoCode)

    this.citySelectTarget.innerHTML = '';

    cities.forEach((city) => {
      const option = document.createElement("option");
      option.value = city.name;
      option.text = city.name;
      option.setAttribute('data-country-code', countryId);
      this.citySelectTarget.appendChild(option);
    });
  }
}
