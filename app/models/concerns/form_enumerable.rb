module FormEnumerable
  extend ActiveSupport::Concern

  included do
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

    NEED_CHOICES = [5, 6, 7]

    HAS_DEFAULT_CHOICES = [8, 9]
  end

  def needs_choices?
    NEED_CHOICES.include?(self.form_cd)
  end

  def has_default_choices?
    HAS_DEFAULT_CHOICES.include?(self.form_cd)
  end

  module ClassMethods
  end
end
