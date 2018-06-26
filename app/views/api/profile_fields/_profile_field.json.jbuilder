json.extract! profile_field, :id, :label, :optional, :form
if profile_field.needs_choices? && !profile_field.has_default_choices?
  json.choices profile_field.choices_with_locale
end
