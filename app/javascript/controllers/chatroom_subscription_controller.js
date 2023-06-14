import { Controller } from "@hotwired/stimulus"
import { createConsumer } from "@rails/actioncable"

export default class extends Controller {
  static values = { chatroomId: Number, userId: Number }
  static targets = ["messages", "input"]

  connect() {
    this.channel = createConsumer().subscriptions.create(
      { channel: "ChatroomChannel", id: this.chatroomIdValue },
      { received: data => this.#insertMessageAndScrollDown(data) }
    )
    console.log(`Subscribed to the chatroom with the id ${this.chatroomIdValue}.`)
  }

  #insertMessageAndScrollDown(data) {
    if (data.user_id !== this.userIdValue) {
      data.html_message = data.html_message.replace("my-message", "message")
    }
    this.messagesTarget.insertAdjacentHTML("beforeend", data.html_message)
    this.messagesTarget.scrollTo(0, this.messagesTarget.scrollHeight)
  };

  resetForm(event) {
    console.log(event);
    event.target.reset()
  }
};
