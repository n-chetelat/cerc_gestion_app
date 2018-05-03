class BoardChannel < ApplicationCable::Channel
  def subscribed
    stream_from "board"
    send_status_message({"type" => "logged_in"})
    send_participant_info
  end

  def unsubscribed
    connection.server.remote_connections
      .where(current_admin_user: current_admin_user).disconnect
    connection.close
    send_status_message({"type" => "logged_out"})
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

  def send_status_message(data)
    message_content = format_message(data)
    ActionCable.server.broadcast "board",
      { message: {author: current_admin_user.slice(:email),
        content: message_content, timestamp: DateTime.now} }
  end


  private

    def format_message(data)
      data.stringify_keys!
      message_str = BoardChannelService::MESSAGE_TYPES[data["type"].to_sym]
      return if message_str.blank?
      {
        "user" => data["params"].try(:[], "user") || current_admin_user.full_name,
        "applicant" => data["params"].try(:[], "applicant"),
        "phase" => data["params"].try(:[], "phase")
      }.compact.each do |attr, source|
        message_str = message_str.gsub("%#{attr}%", source)
      end
      message_str
    end


end
