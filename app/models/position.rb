class Position < ApplicationRecord

  translates :title
  active_admin_translates :title do
    validates_uniqueness_of :title, scope: :locale
  end

end
