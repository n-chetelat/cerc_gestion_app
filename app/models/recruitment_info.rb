class RecruitmentInfo < ApplicationRecord

  validates :singleton_guard, inclusion: { in: [0] }
  validates :singleton_guard, uniqueness: true

  translates :content
  active_admin_translates :content

  globalize_accessors :locales => [:en, :fr], :attributes => [:content]

  def to_s
    "Information"
  end
end
