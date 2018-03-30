class RecruitmentMailer < ApplicationMailer

  def application_received_email(person)
    @person = person
    @application = person.application
    subject = ActionController::Base.helpers.t("action_mailer.recruitment_mailer.received",
      locale: @application.locale)
    mail(to: @person.email, subject: subject)
  end

end
