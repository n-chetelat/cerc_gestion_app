class ApplicationMaterialsMailer < ApplicationMailer

  def send_application_materials
    @application = params[:application]
    @fields = params[:fields]
    @attachment_path = params[:attachment_path]
    attachments[@attachment_path] = File.read(@attachment_path)
    person_name = @application.person.full_name
    mail(from: ENV["GMAIL_ADDRESS"], to: ENV["GMAIL_ADDRESS"], subject: "Application materials for #{person_name}")
  end

end
