json.person_id @person.uuid
json.threads @person.threads.recently_updated, partial: "api/persons/thread", as: :thread
