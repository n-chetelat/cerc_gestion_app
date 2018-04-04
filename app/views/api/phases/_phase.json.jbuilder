json.extract! phase, :id, :created_at, :title, :description, :gmail_label
json.persons phase.persons, partial: "api/persons/person", as: :person, locals: { scopes: ["application"] }
