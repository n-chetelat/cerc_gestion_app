module Positions
  class FormField < ApplicationRecord
    include ::FormEnumerable

    self.table_name = "positions_form_fields"

    belongs_to :recruitment_form, class_name: "Positions::RecruitmentForm", foreign_key: "recruitment_form_id"

    translates :label

    I18n.available_locales.each do |locale|
      define_method("label_#{locale}".to_sym) do
        self.translations.find_by(locale: locale.to_sym).try(:label)
      end

      define_method("label_#{locale}=".to_sym) do |label|
        translation = self.translations.find_or_create_by(locale: locale.to_sym)
        unless label == translation.label
          translation.label = label
          translation.save!
        end
      end
    end

  end
end
