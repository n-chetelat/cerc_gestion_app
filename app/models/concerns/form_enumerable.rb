module FormEnumerable
  extend ActiveSupport::Concern

  included do
    as_enum :form, {
      text: 0,
      textarea: 1,
      checkbox: 2,
      radio: 3,
      date: 4,
      select: 5,
      upload: 6
    }

    validates :form_cd, presence: true
  end

  module ClassMethods
  end
end
