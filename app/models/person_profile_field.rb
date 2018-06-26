class PersonProfileField < ApplicationRecord

  self.table_name = "persons_profile_fields"

  belongs_to :profile_field
  belongs_to :person

  delegate :form, to: :profile_field

  def starting_date_to_s
    case self.form
    when :semester
      self.profile_field.class.semester_to_s(self.data)
    when :month
      self.profile_field.class.month_to_s(self.data)
    else
      nil
    end
  end

end
