json.extract! phase, :id, :created_at, :title, :description, :uuid, :color
json.email_label phase.email_label_name
json.has_callback phase.email_template.present?
json.persons phase.persons, partial: "api/persons/person", as: :person, locals: { scopes: ["application"] }
