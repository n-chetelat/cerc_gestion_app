json.extract! phase, :id, :created_at, :title, :description, :email_label_name
json.persons phase.persons, partial: "api/persons/person", as: :person, locals: { scopes: ["application"] }
