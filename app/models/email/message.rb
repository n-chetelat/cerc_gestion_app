module Email
  class Message < ApplicationRecord

    self.table_name = "email_messages"

    belongs_to :thread, class_name: "Email::Thread", foreign_key: "email_thread_id", inverse_of: :messages, touch: true

    scope :new_to_old, -> { order(google_timestamp: :desc) }

    def html_content
      parsed = Mail.new(self.content)
      parsed.html_part.try(:body).try(:raw_source)
      if html = parsed.html_part.try(:body).try(:raw_source)
        Nokogiri::XML.fragment(html).to_html
      end
    end

    def text_content
      parsed = Mail.new(self.content)
      parsed.text_part.try(:body).try(:raw_source)
    end

    def timestamp
      Time.at(self.google_timestamp.to_i / 1000).to_datetime
    end

    def snippet
      if text = self.text_content
        text.lines.first.try(:truncate, 30)
      end
    end

  end
end
