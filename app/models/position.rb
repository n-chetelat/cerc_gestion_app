class Position < ApplicationRecord

  before_save :add_recruitment_form

  translates :title
  active_admin_translates :title do
    validates_uniqueness_of :title, scope: :locale
  end

  has_one :recruitment_form, class_name: "Positions::RecruitmentForm", dependent: :destroy
  has_many :application, foreign_key: "position_id"

  accepts_nested_attributes_for :recruitment_form

  def duplicate!
    self.with_lock do
      copy = self.class.new
      self.translations.each do |translation|
        tr = copy.translations.build(translation.attributes.slice("locale", "title"))
        tr.title = "#{tr.title} - Copy"
      end
      form = copy.build_recruitment_form
      copy.save!

      self.recruitment_form.form_fields.each do |field|
        new_field = form.form_fields.build(field.attributes
          .slice("position", "form_cd", "options"))
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
