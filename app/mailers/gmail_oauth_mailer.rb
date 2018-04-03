class GmailOauthMailer < ApplicationMailer

  def authorization_needed
    mail(from: "no-reply@polymtl.ca", to: ENV["GMAIL_ADDRESS"], subject: "Gmail Authorization Needed")
  end

end
