class Person < ApplicationRecord

  validates :name, :lastname, :email, presence: true
  validates :email, uniqueness: true
  validate :validate_email_format

  has_one :application, foreign_key: "person_id"
  has_many :persons_phases, class_name: "PersonPhase", foreign_key: "person_id", dependent: :destroy

  scope :not_in_phase, -> { where.not(id: joins(:persons_phases).select(:person_id)) }

  def validate_email_format
    unless email =~ /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i
      errors.add(:email, "is not email")
    end
  end

  def full_name
    [self.name, self.lastname].map(&:presence)
      .compact.join(" ")
  end

  def to_s
    self.full_name
  end

  def current_phase
    PersonPhase.find_by(person_id: self.id).try(:phase)
  end

  def current_position
    self.application.try(:position)
  end

end
