module Email
  class Token < ApplicationRecord

    self.table_name = "email_tokens"

    validates :name, uniqueness: true

  end
end
