json.extract! message, :id, :google_message_id, :from_address
json.thread_id message.email_thread_id
json.content message.html_content || message.text_content
json.to_addresses message.to_addresses || []
json.snippet message.snippet(true)
json.timestamp epoch_to_timesamp(message.google_timestamp.to_i / 1000)
