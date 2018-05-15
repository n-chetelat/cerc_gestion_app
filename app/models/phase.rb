class Phase < ApplicationRecord
  include Uuid

  validates :title, presence: true
  validates :title, uniqueness: true

  before_save :switch_to_initial
  validate :initial_phase_present
  validate :only_one_initial_phase

  has_many :persons_phases, class_name: "PersonPhase", foreign_key: "phase_id"
  has_many :persons, through: :persons_phases

  has_many :boards_phases, class_name: "BoardPhase"
  has_many :boards, through: :boards_phases

  has_one :phases_callback, class_name: "Phases::Callback", dependent: :destroy
  has_one :email_template, through: :phases_callback

  has_one :email_label, class_name: "Email::Label", foreign_key: "phase_id", dependent: :destroy, inverse_of: :phase

  accepts_nested_attributes_for :phases_callback, allow_destroy: true

  def to_s
    self.title
  end

  def email_label_name
    self.email_label.try(:name)
  end

  def email_label_name=(email_label)
  end

  def no_color=(no_color)
    if no_color == "1"
      self.color = nil
    end
  end

  def no_color
    self.color.blank?
  end

  def self.current_initial
    self.find_by(initial: true)
  end

  private

    def switch_to_initial
      return unless self.initial

      initials = self.class.where(initial: true)
      initials.update(initial: false)

      self.initial = true
    end

    def initial_phase_present
      initials = self.class.where(initial: true)
      unless (self.initial || initials.where.not(id: self.id).any?)
        self.errors.add(:initial, " There needs to be an initial tag.")
      end
    end

    def only_one_initial_phase
      return unless self.initial

      initials = self.class.where(initial: true).where.not(id: self.id)

      if initials.any?
        self.errors.add(:initial, " There can only be one initial tag.")
      end
    end

end
