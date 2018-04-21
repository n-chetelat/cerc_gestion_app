class Board < ApplicationRecord

  before_validation :set_slug, if: Proc.new {|board| board.changes["title"].present? }

  has_many :boards_phases, -> { order(position: :asc) }, class_name: "BoardPhase", dependent: :destroy
  has_many :phases, through: :boards_phases

  accepts_nested_attributes_for :boards_phases, allow_destroy: true

  validates :title, :slug, presence: true
  validates :title, :slug, uniqueness: true

  def set_slug
    self.slug = self.title.parameterize(separator: "_")
  end
end
