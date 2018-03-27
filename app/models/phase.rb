class Phase < ApplicationRecord

  validates :title, presence: true
  validates :title, uniqueness: true

  before_save :switch_to_initial
  validate :initial_phase_present
  validate :only_one_initial_phase

  has_many :persons_phases, class_name: "PersonPhase", foreign_key: "phase_id"
  has_many :persons, through: :persons_phases

  has_many :boards_phases, class_name: "BoardPhase", dependent: :destroy
  has_many :boards, through: :boards_phases

  def to_s
    self.title
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

  def self.current_initial
    self.find_by(initial: true)
  end

  private

    def switch_to_initial
      return unless self.initial

      self.with_lock do
        initials = self.class.where(initial: true)
        initials.update(initial: false)

        self.initial = true

        persons_phases_id = initials.joins(:persons_phases).select(:id)
      end
    end

end
