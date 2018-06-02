module Positions
  class FormField < ApplicationRecord
    include ::FormEnumerable
    include ::StartingDates

    self.table_name = "positions_form_fields"

    store_accessor :options, :choices, :locale_choices

    belongs_to :recruitment_form, class_name: "Positions::RecruitmentForm", foreign_key: "recruitment_form_id"

    translates :label
    globalize_accessors :locales => [:en, :fr], :attributes => [:label]

    acts_as_list scope: :recruitment_form

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

    def choices_with_locale(locale = I18n.locale)
      if self.needs_choices?
        self.locale_choices.map {|id, line| {id: id, label: line[locale.to_s]} }
      elsif self.has_default_choices?
        self.default_choices
      else
        nil
      end
    end

    def default_choices
      return nil unless self.has_default_choices?
      self.class.generate_starting_dates(self.form)
    end

  end
end
