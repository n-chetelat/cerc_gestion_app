class GmailOauthMailer < ApplicationMailer

  def authorization_needed
    mail(from: ENV["GMAIL_ADDRESS"], to: ENV["GMAIL_ADDRESS"], subject: "Gmail Authorization Needed")
  end

end
