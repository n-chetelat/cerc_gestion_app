class Application < ApplicationRecord

  store_accessor :fields

  belongs_to :person, foreign_key: "person_id"
  belongs_to :position, foreign_key: "position_id"

  validates :starting_semester, presence: true

end
