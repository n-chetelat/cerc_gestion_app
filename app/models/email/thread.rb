module Email
  class Thread < ApplicationRecord

    self.table_name = "email_threads"

    has_many :messages, class_name: "Email::Message", foreign_key: "email_thread_id", dependent: :destroy, inverse_of: :thread

    has_many :persons_threads, class_name: "Email::PersonThread", foreign_key: "email_thread_id", dependent: :destroy, inverse_of: :thread
    has_many :threads, through: :persons_threads

  end
end
