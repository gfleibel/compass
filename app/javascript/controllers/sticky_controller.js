import { Controller } from 'stimulus';

export default class extends Controller {
  connect() {
    window.addEventListener('scroll', this.handleScroll);
    console.log('Sticky controller connected!');
  }

  disconnect() {
    window.removeEventListener('scroll', this.handleScroll);
  }

  handleScroll = () => {
    const container = this.element;
    const containerRect = container.getBoundingClientRect();

    if (containerRect.top <= 0) {
      container.classList.add('sticky');
    } else {
      container.classList.remove('sticky');
    }
  }
}
