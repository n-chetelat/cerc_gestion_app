class Application < ApplicationRecord
  include Semesters

  store_accessor :fields

  belongs_to :person, foreign_key: "person_id"
  belongs_to :position, foreign_key: "position_id"


  validates :starting_semester, presence: true

  def starting_semester_to_s
    self.class.semester_to_s(self.starting_semester)
  end

end
