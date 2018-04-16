json.person_id @person.id
json.threads @person.threads.recently_updated, partial: "api/persons/thread", as: :thread
