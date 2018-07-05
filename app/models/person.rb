class Person < ApplicationRecord
  include Uuid

  before_save :create_email_address

  validates :name, :lastname, :email, presence: true
  validate :validate_email_format

  has_one :application, foreign_key: "person_id", dependent: :destroy

  has_many :persons_phases, class_name: "PersonPhase", foreign_key: "person_id", dependent: :destroy
  has_many :email_addresses, class_name: "Persons::EmailAddress", foreign_key: "person_id", dependent: :destroy

  has_many :persons_threads, class_name: "Email::PersonThread", foreign_key: "person_id", dependent: :destroy, inverse_of: :person
  has_many :threads, through: :persons_threads

  has_many :persons_profile_fields, class_name: "PersonProfileField", foreign_key: "person_id", dependent: :destroy

  has_many :persons_positions_milestones, class_name: "::PersonPositionsMilestone",  dependent: :destroy
  has_many :positions_milestones, through: :persons_positions_milestones

  scope :not_in_phase, -> { where.not(id: joins(:persons_phases).select(:person_id)) }
  scope :accepted, -> { joins(:application).where("applications.closed_at IS NOT NULL AND applications.accepted = TRUE") }
  scope :rejected, -> { joins(:application).where("applications.closed_at IS NOT NULL AND applications.accepted = FALSE") }
  scope :active, -> { accepted.where(finished_at: nil) }
  delegate :starting_date, to: :application

  def create_email_address
    unless self.email_addresses.exists?(address: self.email)
      self.email_addresses.build(address: self.email)
    end
  end

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

  def position
    self.application.try(:position)
  end

  def starting_date_label
    if self.application.present?
      self.application.starting_date_to_s
    end
  end

  def accepted?
    self.class.accepted.exists?(id: self.id)
  end

end
