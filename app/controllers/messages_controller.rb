class MessagesController < ApplicationController
  def create
    @chatroom = policy_scope(Chatroom)
    @chatroom = Chatroom.find(params[:chatroom_id])
    @message = build_message
    authorize @message
    return render "chatrooms/show", status: :unprocessable_entity unless @message.save

    broadcast_message_to_chatroom
    head :ok
  end

  private

  def message_params
    params.require(:message).permit(:content)
  end

  def build_message
    message = Message.new(message_params)
    message.chatroom = @chatroom
    message.user = current_user
    message
  end
  
  def broadcast_message_to_chatroom
    ChatroomChannel.broadcast_to(
      @chatroom,
      {
        html_message: render_to_string(partial: "message", locals: { message: @message }),
        user_id: @message.user.id
      }
    )
  end
end
