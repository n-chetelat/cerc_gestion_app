module Email
  class Message < ApplicationRecord

    self.table_name = "email_messages"

    belongs_to :thread, class_name: "Email::Thread", foreign_key: "email_thread_id", inverse_of: :messages

  end
end
