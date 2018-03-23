json.extract! application, :id, :created_at
json.starting_semester application.starting_semester_to_s
json.name application.person.full_name
json.position application.position.title
json.email application.person.email
