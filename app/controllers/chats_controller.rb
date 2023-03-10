class ChatsController < ApplicationController
  def show
    @user = User.find(params[:id])
    rooms = current_user.user_rooms.pluck(:room_id)
    user_room = UserRoom.find_by(user_id: @user.id, room_id: rooms)
    # room=nil
    if user_room.nil?
      room = Room.new
      room.save
      UserRoom.create(user_id: @user.id, room_id: room.id)
      UserRoom.create(user_id: current_user.id, room_id: room.id)
    else
      room=user_room.room
    end
    @chats =room.chats
    @chat=Chat.new(room_id: room.id)
  end
  
  def create
    @chat = current_user.chats.new(chat_params)
    @chat.save
    redirect_to request.referer
  end
  
  def destroy
    @chat=Chat.find(params[:id])
    @chat.destroy
    redirect_to request.referer
  end
  
  
  private
  
  def chat_params
    params.require(:chat).permit(:message, :room_id)
  end
end
