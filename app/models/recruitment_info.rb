class RecruitmentInfo < ApplicationRecord

  validates :singleton_guard, inclusion: { in: [0] }
  validates :singleton_guard, uniqueness: true

  translates :content, :copyright, :positions
  active_admin_translates :content, :copyright, :positions

  globalize_accessors :locales => [:en, :fr], :attributes => [:content, :copyright, :positions]

  def to_s
    "Information"
  end
end
