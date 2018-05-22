json.extract! phase, :id, :created_at, :title, :description, :uuid, :color
json.email_label phase.email_label_name
json.has_callback phase.email_template.present?
json.persons phase.persons_phases_not_deleted.order(updated_at: :asc) do |person_phase|
  json.moved_at person_phase.updated_at
  json.partial! "api/persons/person", person: person_phase.person
end
