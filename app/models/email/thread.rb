module Email
  class Thread < ApplicationRecord

    self.table_name = "email_threads"

    before_save :set_subject_line, if: Proc.new {|thread| thread.subject.blank? }
    before_save :set_google_create_timestamp, if: Proc.new {|thread| thread.google_create_timestamp.blank? }
    before_save :set_google_update_timestamp

    has_many :messages, class_name: "Email::Message", foreign_key: "email_thread_id", dependent: :destroy, inverse_of: :thread

    has_many :persons_threads, class_name: "Email::PersonThread", foreign_key: "email_thread_id", dependent: :destroy, inverse_of: :thread
    has_many :persons, through: :persons_threads

    scope :new_to_old, -> { order(google_create_timestamp: :desc) }
    scope :recently_updated, -> { order(google_update_timestamp: :desc) }

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

    def set_google_create_timestamp
      if self.messages.any?
        self.google_create_timestamp = self.messages.new_to_old.last.google_timestamp
      end
    end

    def set_google_update_timestamp
      if self.messages.any?
        self.google_update_timestamp = self.messages.new_to_old.first.google_timestamp
      end
    end

    def participants
      self.persons.pluck(:email).uniq
    end

  end
end
