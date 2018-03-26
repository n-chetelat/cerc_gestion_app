json.extract! person, :id, :created_at
json.name person.full_name
json.application_id person.application.id
json.email person.email
