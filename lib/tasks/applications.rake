desc "Delete all applications marked for deletion"
task :delete_marked_applications => :environment do
  applications = Application.where(to_delete: true)

  applications.each do |application|
    person = application.person
    person.threads.destroy_all
    person.destroy!
  end
end
