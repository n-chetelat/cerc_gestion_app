json.extract! thread, :id, :created_at, :updated_at
json.subject thread.subject
json.messages thread.messages.new_to_old, partial: "api/persons/message", as: :message
