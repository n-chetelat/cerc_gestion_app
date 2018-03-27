json.extract! person, :id, :created_at
json.name person.full_name
json.email person.email

if person.application
  json.application do
    json.partial! "api/applications/application", application: person.application
  end
end
