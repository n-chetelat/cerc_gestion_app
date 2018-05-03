class BoardChannelService

  def self.send_phases_update(slugs)
    ActionCable.server.broadcast "board", {refresh_phases: {board_ids: slugs}}
  end

  def self.send_comments_update(application)
    ActionCable.server.broadcast "board", { refresh_comments: {application_id: application.id} }
  end

  def self.send_emails_update(person_id)
    ActionCable.server.broadcast "board", { refresh_emails: {person_id: person_id} }
  end

  def self.send_new_application_message
    ActionCable.server.broadcast "board",
      { message: {author: "new_application",
        content: MESSAGE_TYPES[:new_application], timestamp: DateTime.now} }
  end

  MESSAGE_TYPES = {
    logged_in: "%user% has logged in.",
    logged_out: "%user% has logged out.",
    comment: "%user% has left a comment about %applicant% in column '%phase%'",
    composing: "%user% has started composing an email for %applicant% in column '%phase%'",
    email: "%user% has sent an email to %applicant% in column '%phase%'",
    phase_change: "%user% has moved %applicant% to column '%phase%'",
    application_change: "%user% has made a change to an application: %applicant% in column '%phase%'",
    new_application: "A new application has been submitted."
  }

end
