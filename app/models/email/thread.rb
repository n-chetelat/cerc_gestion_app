module Email
  class Thread < ApplicationRecord

    self.table_name = "email_threads"

    before_save :set_subject_line, if: Proc.new {|thread| thread.subject.blank? }

    has_many :messages, class_name: "Email::Message", foreign_key: "email_thread_id", dependent: :destroy, inverse_of: :thread

    has_many :persons_threads, class_name: "Email::PersonThread", foreign_key: "email_thread_id", dependent: :destroy, inverse_of: :thread
    has_many :persons, through: :persons_threads

    def email_labels
      self.persons.map do |person|
        person.current_phase.email_label.try(:google_label_id)
      end.compact
    end

    def set_subject_line
      if self.messages.any?
        mail = Mail.new(self.messages.first.content)
        self.subject = mail.subject
      end
    end

  end
end
