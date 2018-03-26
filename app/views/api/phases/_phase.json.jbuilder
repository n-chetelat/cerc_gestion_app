json.extract! phase, :id, :created_at, :title, :description
json.persons phase.persons, partial: "api/persons/person", as: :person
