json.extract! thread, :id, :updated_at
json.messages thread.messages, partial: "api/persons/message", as: :message
