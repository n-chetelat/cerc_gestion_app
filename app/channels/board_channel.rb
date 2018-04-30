class BoardChannel < ApplicationCable::Channel
  def subscribed
    stream_from "board"
  end

  def send_user_info
    ActionCable.server.broadcast "board", user: current_admin_user.slice(:name, :lastname, :email)
  end


end
