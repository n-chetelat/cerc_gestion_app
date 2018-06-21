class ProfileField < ApplicationRecord

  self.table_name = "profile_fields"

  store_accessor :options, :choices, :locale_choices

  has_many :persons_profile_fields, class_name: "PersonProfileField", dependent: :destroy

  validates :label, uniqueness: true, unless: Proc.new {|f| f.form_field_id.present? }

end
