json.extract! field, :id, :profile_field_id
json.value field.data
if field.profile_field.has_default_choices?
  json.starting_date_label field.starting_date_to_s
end
