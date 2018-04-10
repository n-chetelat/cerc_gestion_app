scopes ||= @scopes
json.extract! person, :id
json.full_name person.full_name
json.email person.email
json.phase person.current_phase.id
