json.extract! phase, :id, :created_at, :title, :description
json.email_label phase.email_label_name
json.persons phase.persons, partial: "api/persons/person", as: :person, locals: { scopes: ["application"] }
