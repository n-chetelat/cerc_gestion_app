class Application < ApplicationRecord
  include Semesters

  before_save :clean_up_unused_fields, unless: :new_record?

  store_accessor :fields

  belongs_to :person, foreign_key: "person_id"
  belongs_to :position, foreign_key: "position_id"


  validates :starting_semester, presence: true

  def starting_semester_to_s
    self.class.semester_to_s(self.starting_semester)
  end


  def fields_for_current_position
    self.fields.select do |key, value|
      form_field_type, form_field_id = /input_(\w+)_(\d+)/.match(key).captures
      self.position.recruitment_form.form_fields.exists?(id: form_field_id)
    end
  end
  
  def clean_up_unused_fields
    self.fields.each do |key, value|
      form_field_type, form_field_id = /input_(\w+)_(\d+)/.match(key).captures
      unless self.position.recruitment_form.form_fields.exists?(id: form_field_id)
        self.fields.delete(key)
      end
    end
  end

end
