class PersonProfileField < ApplicationRecord

  self.table_name = "persons_profile_fields"

  belongs_to :profile_field
  belongs_to :person

end
