json.extract! person, :id, :name, :lastname, :uuid
json.full_name person.full_name
json.email person.email
json.position_id person.position.id

application = person.application

json.starting_date application.starting_date
json.starting_date_label application.starting_date_to_s
json.starting_date_type application.position.time_interval
json.applied_at application.created_at.to_formatted_s(:short)
json.closed_at application.closed_at.to_formatted_s(:short)

json.profile_fields person.persons_profile_fields do |field|
  json.partial! "api/profiles/profile_field", field: field
end
