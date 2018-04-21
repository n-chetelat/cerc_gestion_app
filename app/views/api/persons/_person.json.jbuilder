scopes ||= @scopes
json.extract! person, :id, :name, :lastname, :uuid
json.full_name person.full_name
json.email person.email
json.phase_id person.current_phase.try(:uuid)

if scopes.include?("application")
  json.application_id person.application.id
  json.position person.position.try(:title)
  json.starting_date person.application.starting_date_to_s
  json.starting_date_id person.application.starting_date
  json.applied_at person.application.created_at.to_formatted_s(:short)
end
