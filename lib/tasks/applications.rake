desc "Clean up materials for all applications marked as closed"
task :delete_closed_application_data => :environment do
  applications = Application.where.not(closed_at: nil)

  applications.each do |application|
    person = application.person

    # remove unused correspondence
    person.threads.destroy_all

    # remove attachments from local db and from gcloud
    application.attachments.each do |attachment|
      begin
        attachment.file.try(:destroy!)
        attachment.destroy!
      rescue
        next
      end
    end
  end

end

desc "Delete files not attached to an application"
task :delete_unused_files => :environment do
  used_attachment_ids = Application.all.map(&:attachment_ids).flatten
  to_delete = Attachment.where.not(id: used_attachment_ids)

  to_delete.each do |attachment|
    begin
      attachment.file.try(:destroy!)
      attachment.destroy!
    rescue
      next
    end
  end
end
