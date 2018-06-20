class PersonProfileField < ApplicationRecord

  self.table_name = "profile_fields"

  belongs_to :profile_field
  belongs_to :person

end
