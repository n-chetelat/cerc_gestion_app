module Email
  class Message < ApplicationRecord

    self.table_name = "email_messages"

    belongs_to :thread, class_name: "Email::Thread", foreign_key: "email_thread_id", inverse_of: :messages, touch: true

    def html_content
      parsed = Mail.new(self.content)
      parsed.html_part.try(:body).try(:raw_source)
      if html = parsed.html_part.try(:body).try(:raw_source)
        Nokogiri::XML.fragment(html).to_html
      end
    end

  end
end
