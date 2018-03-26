json.extract! person, :id, :created_at
json.name person.full_name
json.email person.email
json.position person.current_position.try(:to_s)
json.application_id person.application.try(:id)
