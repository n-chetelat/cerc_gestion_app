json.extract! thread, :id
json.subject thread.subject
json.timestamp epoch_to_timesamp(thread.google_update_timestamp.to_i / 1000)
json.participants thread.participants
json.messages thread.messages.new_to_old, partial: "api/persons/message", as: :message
