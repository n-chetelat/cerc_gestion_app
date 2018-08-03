class Person < ApplicationRecord
  include Uuid

  validates :name, :lastname, :email, presence: true
  validate :validate_email_format

  has_one :application, foreign_key: "person_id", dependent: :destroy

  has_one :persons_phase, class_name: "PersonPhase", foreign_key: "person_id", dependent: :destroy

  has_many :persons_threads, class_name: "Email::PersonThread", foreign_key: "person_id", dependent: :destroy, inverse_of: :person
  has_many :threads, through: :persons_threads

  has_many :persons_profile_fields, class_name: "PersonProfileField", foreign_key: "person_id", dependent: :destroy

  has_many :persons_positions_milestones, class_name: "::PersonPositionsMilestone",  dependent: :destroy
  has_many :positions_milestones, through: :persons_positions_milestones

  scope :in_recruitment, -> { joins(:application).where("applications.closed_at IS NULL") }
  scope :post_recruitment, -> { joins(:application).where("applications.closed_at IS NOT NULL") }
  scope :not_in_phase, -> { in_recruitment.where.not(id: joins(:persons_phase).select(:person_id)) }
  scope :accepted, -> { joins(:application).where("applications.closed_at IS NOT NULL AND applications.accepted = TRUE") }
  scope :rejected, -> { joins(:application).where("applications.closed_at IS NOT NULL AND applications.accepted = FALSE") }
  scope :active, -> { accepted.where(finished_at: nil) }

  delegate :starting_date, to: :application

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
    self.persons_phase.try(:phase)
  end

  def position
    self.application.try(:position)
  end

  def starting_date_label
    if self.application.present?
      self.application.starting_date_to_s
    end
  end

  def in_recruitment?
    self.class.in_recruitment.exists?(id: self.id)
  end

  def accepted?
    self.class.accepted.exists?(id: self.id)
  end

  def active?
    self.class.active.exists?(id: self.id)
  end

end
