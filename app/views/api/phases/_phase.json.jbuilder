json.extract! phase, :id, :created_at, :title, :description, :email_label
json.persons phase.persons, partial: "api/persons/person", as: :person, locals: { scopes: ["application"] }
