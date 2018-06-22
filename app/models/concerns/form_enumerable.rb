module FormEnumerable
  extend ActiveSupport::Concern
  include ::StartingDates

  NEED_CHOICES = [5, 6, 7]
  HAS_DEFAULT_CHOICES = [8, 9]
  UPLOADS = [2, 3]

  included do
    store_accessor :options, :choices, :locale_choices

    as_enum :form, {
      text: 0,
      textarea: 1,
      upload_single: 2,
      upload_multiple: 3,
      date: 4,
      select: 5,
      checkbox: 6,
      radio: 7,
      month: 8,
      semester: 9,
    }

    validates :form_cd, presence: true

    scope :without_uploads, -> { where.not(form_cd: UPLOADS) }
  end

  def needs_choices?
    NEED_CHOICES.include?(self.form_cd)
  end

  def has_default_choices?
    HAS_DEFAULT_CHOICES.include?(self.form_cd)
  end

  def choices_with_locale(locale = I18n.locale)
    if self.needs_choices?
      self.locale_choices.map {|id, line| {id: id, label: line[locale.to_s]} }
    elsif self.has_default_choices?
      self.default_choices
    else
      nil
    end
  end

  def default_choices
    return nil unless self.has_default_choices?
    self.class.generate_starting_dates(self.form)
  end

  module ClassMethods
  end
end
