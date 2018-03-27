scopes ||= @scopes
json.extract! person, :id
json.full_name person.full_name
json.email person.email

if scopes.include?("application")
  json.application_id person.application.id
  json.position person.position.try(:title)
  json.starting_semester person.application.starting_semester_to_s
  json.applied_at person.application.created_at.to_formatted_s(:short)
end
