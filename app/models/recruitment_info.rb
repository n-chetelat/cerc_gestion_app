class RecruitmentInfo < ApplicationRecord

  validates :singleton_guard, inclusion: { in: [0] }
  validates :singleton_guard, uniqueness: true

end
