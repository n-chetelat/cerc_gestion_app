json.person_id @person.uuid
json.threads @person.threads.from_more_recently_updated, partial: "api/persons/thread", as: :thread
