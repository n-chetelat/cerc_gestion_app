json.extract! application, :id
json.starting_semester application.starting_semester_to_s
json.person_id application.person.id
json.position application.position.title
json.created_at application.created_at.to_formatted_s(:short)

json.form_fields @form_fields do |field|
  json.id field[:form_field_id]
  json.type field[:type].to_s.gsub(/_/, "-")
  json.label field[:label]
  json.value field[:value]
end
