json.extract! application, :id
json.starting_semester application.starting_semester_to_s
json.name application.person.full_name
json.position application.position.title
json.email application.person.email
json.created_at application.created_at.to_formatted_s(:short)

if @version == "long"
  json.form_fields application.fields
end
