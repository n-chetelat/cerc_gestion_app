module Positions
  class FormField < ApplicationRecord
    include ::FormEnumerable

    self.table_name = "positions_form_fields"

    store_accessor :options, :choices

    belongs_to :recruitment_form, class_name: "Positions::RecruitmentForm", foreign_key: "recruitment_form_id"

    translates :label
    globalize_accessors :locales => [:en, :fr], :attributes => [:label]

    acts_as_list scope: :recruitment_form, top_of_list: 0



  end
end
