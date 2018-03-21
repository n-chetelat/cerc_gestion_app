class Application < ApplicationRecord

  store_accessor :fields

  belongs_to :person, foreign_key: "person_id"

  validate :starting_semester, presence: true

end
