module Email
  class Message < ApplicationRecord

    self.table_name = "email_messages"

    before_save :set_to_addresses, if: Proc.new {|message| message.to_addresses.nil? }

    belongs_to :thread, class_name: "Email::Thread", foreign_key: "email_thread_id", inverse_of: :messages, touch: true

    scope :new_to_old, -> { order(google_timestamp: :desc) }

    validates :content, :google_message_id, presence: true

    def html_content
      parsed = Mail.new(self.content)
      parsed.html_part.try(:body).try(:raw_source)
      if html = parsed.html_part.try(:body).try(:raw_source)
        Nokogiri::XML.fragment(html).to_html
      else
    end

    def text_content
      parsed = Mail.new(self.content)
      parsed.text_part.try(:body).try(:raw_source)
    end

    def timestamp
      Time.at(self.google_timestamp.to_i / 1000).to_datetime
    end

    def snippet(html=false)
      text = self.html_content if html
      text = self.text_content if text.nil?
      if text
        text.lines.first.try(:truncate, 30)
      end
    end

    def set_to_addresses
      mail = Mail.new(self.content)
      self.to_addresses = mail.to
    end

  end
end
