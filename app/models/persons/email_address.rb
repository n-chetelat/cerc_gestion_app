module Persons
  class EmailAddress < ApplicationRecord

    self.table_name = "email_addresses"

    belongs_to :person
  end
end
