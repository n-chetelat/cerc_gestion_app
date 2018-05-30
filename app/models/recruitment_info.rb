class RecruitmentInfo < ApplicationRecord

  validates :singleton_guard, inclusion: { in: [0] }
  validates :singleton_guard, uniqueness: true

  translates :content, :copyright, :positions, :terms
  active_admin_translates :content, :copyright, :positions, :terms

  globalize_accessors :locales => [:en, :fr], :attributes => [:content, :copyright, :positions, :terms]

  def to_s
    "Information"
  end
end
