scopes ||= @scopes
json.extract! person, :id, :name, :lastname
json.full_name person.full_name
json.email person.email
json.phase_id person.current_phase.try(:id)

if scopes.include?("application")
  json.application_id person.application.id
  json.position person.position.try(:title)
  json.starting_semester person.application.starting_semester_to_s
  json.starting_semester_id person.application.starting_semester
  json.applied_at person.application.created_at.to_formatted_s(:short)
end
