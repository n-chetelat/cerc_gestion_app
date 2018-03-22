class Position < ApplicationRecord

  translates :title
  active_admin_translates :title do
    validates_uniqueness_of :title, scope: :locale
  end

  has_one :recruitment_form, class_name: "Positions::RecruitmentForm", dependent: :destroy
  has_many :application, foreign_key: "position_id"

  accepts_nested_attributes_for :recruitment_form

  validates_presence_of :recruitment_form
  validates_associated :recruitment_form

end
