class Position < ApplicationRecord

  before_save :add_recruitment_form

  translates :title
  active_admin_translates :title do
    validates_uniqueness_of :title, scope: :locale
  end

  validates :duration_units, presence: true

  has_one :recruitment_form, class_name: "Positions::RecruitmentForm", dependent: :destroy
  has_many :applications, foreign_key: "position_id"

  has_many :milestones, class_name: "Positions::Milestone", foreign_key: "position_id", dependent: :destroy

  accepts_nested_attributes_for :recruitment_form
  accepts_nested_attributes_for :milestones, allow_destroy: true

  scope :visible, -> { where(hidden: false) }
  scope :hidden, -> { where(hidden: true) }

  store_accessor :options, :ending_date_menu_on_form

  as_enum :time_interval, {
    month: 0,
    semester: 1,
  }

  acts_as_list


  def to_s
    self.title
  end

  def duplicate!
    self.with_lock do
      copy = self.class.new
      self.translations.each do |translation|
        tr = copy.translations.build(translation.attributes.slice("locale", "title"))
        tr.title = "#{tr.title} - Copy"
      end
      copy.hidden = true
      copy.time_interval_cd = self.time_interval_cd
      form = copy.build_recruitment_form
      copy.save!

      self.recruitment_form.form_fields.order(position: :asc).each do |field|
        new_field = form.form_fields.build(field.attributes
          .slice("position", "form_cd", "optional", "options"))
        field.translations.each do |translation|
          tr = new_field.translations.build(translation.attributes.slice("locale", "label"))
          tr.label = "#{tr.label}"
        end
      end

      copy.save!
      copy
    end
  end

  def add_recruitment_form
    self.build_recruitment_form unless self.recruitment_form
  end

  def ending_date_menu_on_form=(value)
    super(value == "1")
  end

end
