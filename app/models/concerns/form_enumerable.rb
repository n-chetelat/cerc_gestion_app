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
    }

    validates :form_cd, presence: true
  end

  module ClassMethods
  end
end
