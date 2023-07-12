class ChatroomsController < ApplicationController
  def show
    @chatroom = Chatroom.find(params[:id])
    @message = Message.new
    authorize @chatroom
    authorize @message
    @mentor = User.find(@chatroom.match.mentor_id)
    @mentee = User.find(@chatroom.match.mentee_id)
  end
end
