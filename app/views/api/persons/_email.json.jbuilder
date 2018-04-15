json.person_id @person.id
json.threads @person.threads.new_to_old, partial: "api/persons/thread", as: :thread
