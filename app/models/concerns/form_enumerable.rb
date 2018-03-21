module FormEnumerable
  extend ActiveSupport::Concern

  included do
    as_enum :form, {
      text: 0,
      textarea: 1,
      upload: 2,
      date: 3,
      select: 4,
      # checkbox: 5,
      # radio: 6,
    }

    validates :form_cd, presence: true
  end

  module ClassMethods
  end
end
