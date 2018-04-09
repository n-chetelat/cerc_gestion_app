module Email
  class PersonThread < ApplicationRecord

    self.table_name = "email_persons_threads"

    belongs_to :thread, class_name: "Email::Thread", foreign_key: "email_thread_id", inverse_of: :persons_threads

    belongs_to :person, class_name: "Person", foreign_key: "person_id", inverse_of: :persons_threads

  end
end
