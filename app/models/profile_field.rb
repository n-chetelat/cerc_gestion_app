class ProfileField < ApplicationRecord
  include ::FormEnumerable

  self.table_name = "profile_fields"

  has_many :persons_profile_fields, class_name: "PersonProfileField", dependent: :destroy

  validates :label, uniqueness: { scope: :form_cd }

  def choices=(ch)
    super
    return nil unless self.needs_choices?
    lines = ch.split("\n").map {|line| line.split(";").map(&:strip) }
    self.locale_choices = {}.tap do |h|
      lines.each_with_index do |line, index|
        key = index.to_s
        h[key] = {en: line[0], fr: line[1]}
      end
    end
  end

end
