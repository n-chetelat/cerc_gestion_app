class BoardChannel < ApplicationCable::Channel
  def subscribed
    stream_from "board"
    send_participant_info
  end

  def unsubscribed
    connection.server.remote_connections
      .where(current_admin_user: current_admin_user).disconnect
    connection.close
    send_participant_info
  end

  def send_participant_info
    participants = []
    connection.server.connections.each do |conn|
      participants << conn.current_admin_user
    end
    participants.uniq! {|user| user.id }
    ActionCable.server.broadcast "board",
      { users: participants.map {|user| user.slice(:name, :lastname, :email) } }
  end

  # def send_status_message(data)
  #   ActionCable.server.broadcast "board",
  #     { message: data.message }
  # end


end
