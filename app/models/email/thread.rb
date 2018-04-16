module Email
  class Thread < ApplicationRecord

    self.table_name = "email_threads"

    before_save :set_subject_line, if: Proc.new {|thread| thread.subject.blank? }
    before_save :set_google_timestamp, if: Proc.new {|thread| thread.google_timestamp.blank? }

    has_many :messages, class_name: "Email::Message", foreign_key: "email_thread_id", dependent: :destroy, inverse_of: :thread

    has_many :persons_threads, class_name: "Email::PersonThread", foreign_key: "email_thread_id", dependent: :destroy, inverse_of: :thread
    has_many :persons, through: :persons_threads

    scope :new_to_old, -> { order(google_timestamp: :desc) }

    def email_labels
      @labels ||= self.persons.map do |person|
        person.current_phase.email_label.try(:google_label_id)
      end.compact
    end

    def set_subject_line
      if self.messages.any?
        mail = Mail.new(self.messages.first.content)
        self.subject = mail.subject
      end
    end

    def set_google_timestamp
      if self.messages.any?
        self.google_timestamp = self.messages.new_to_old.last.google_timestamp
      end
    end

    def participants
      self.messages.pluck(:from_address).uniq - [ENV["GMAIL_ADDRESS"]]
    end

  end
end
