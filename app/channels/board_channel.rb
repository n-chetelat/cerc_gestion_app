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

    MESSAGE_TYPES = {
      logged_in: "%user% has logged in.",
      logged_out: "%user% has logged out.",
      comment: "%user% has left a comment about %applicant% in column '%phase%'",
      composing: "%user% has started composing an email for %applicant% in column '%phase%'",
      email: "%user% has sent an email to %applicant% in column '%phase%'",
      phase_change: "%user% has moved %applicant% to column '%phase%'",
      application_change: "%user% has made a change to an application: %applicant% in column '%phase%'"
    }

    def format_message(data)
      message_str = MESSAGE_TYPES[data["type"].to_sym]
      return if message_str.blank?
      {
        "user" => current_admin_user.full_name,
        "applicant" => data["params"].try(:[], "applicant"),
        "phase" => data["params"].try(:[], "phase")
      }.compact.each do |attr, source|
        message_str = message_str.gsub("%#{attr}%", source)
      end
      message_str
    end


end
