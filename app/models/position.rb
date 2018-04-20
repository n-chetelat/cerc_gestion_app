class Position < ApplicationRecord

  after_initialize :add_default_values
  before_save :add_recruitment_form

  translates :title
  active_admin_translates :title do
    validates_uniqueness_of :title, scope: :locale
  end

  has_one :recruitment_form, class_name: "Positions::RecruitmentForm", dependent: :destroy
  has_many :application, foreign_key: "position_id"

  accepts_nested_attributes_for :recruitment_form

  scope :visible, -> { where(hidden: false) }
  scope :hidden, -> { where(hidden: true) }

  as_enum :time_interval, {
    month: 0,
    semester: 1,
  }

  def to_s
    self.title
  end

  def add_default_values
    self.hidden = true if self.hidden.nil?
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

end
