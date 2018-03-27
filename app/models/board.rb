class Board < ApplicationRecord

  has_many :boards_phases, class_name: "BoardPhase", dependent: :destroy
  has_many :phases, through: :boards_phases

  accepts_nested_attributes_for :boards_phases, allow_destroy: true

  validates :title, presence: true
  validates :title, uniqueness: true

end
