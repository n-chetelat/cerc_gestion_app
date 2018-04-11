json.person_id @person.id
json.threads @person.threads, partial: "api/persons/thread", as: :thread
