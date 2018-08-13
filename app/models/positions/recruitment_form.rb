module Positions
  class RecruitmentForm < ApplicationRecord

    self.table_name = "positions_recruitment_forms"

    attr_accessor :name, :lastname, :email, :starting_date, :ending_date

    belongs_to :position
    has_many :form_fields, class_name: "Positions::FormField", dependent: :destroy, foreign_key: "recruitment_form_id"

    accepts_nested_attributes_for :form_fields, allow_destroy: true

    def common_fields
      fields = self.class.immutable_common_fields

        starting_date_choices = ::DatesService.generate_starting_dates(self.position.time_interval)
        fields << {
          id: "starting_date",
          label: ActionController::Base.helpers.t("activerecord.attributes.positions/recruitment_form.starting_date"),
          options: { choices: starting_date_choices },
          type: "input-select"
        }

        if self.position.ending_date_menu_on_form
          minimum_starting_date = Date.parse(starting_date_choices.first[:id])
          minimum_ending_date = self.get_minimum_ending_date_from(minimum_starting_date)

          fields << {
            id: "ending_date",
            label: ActionController::Base.helpers.t("activerecord.attributes.positions/recruitment_form.ending_date"),
            options: { choices: ::DatesService.generate_starting_dates(self.position.time_interval,
              {min_date: minimum_ending_date, years: 4, months: 24}) },
            type: "input-select"
          }
        end

        fields
    end

    def self.immutable_common_fields
      fields = [:name, :lastname, :email].map do |attr|
        {
          id: attr.to_s,
          label: ActionController::Base.helpers.t("activerecord.attributes.positions/recruitment_form.#{attr}"),
          options: {},
          type: "input-text"
        }
      end
    end

    protected

      def get_minimum_ending_date_from(minimum_starting_date)
        extra_time = (self.position.duration_units || ::Position::DEFAULT_MINIMUM_DURATION)
        if self.position.time_interval == :semester

          # Add 3 semesters (a year) to semester away count to avoid going under required milestone dates.
          # Form choices are shown from first semester of year, even if it would be an invalid choice for milestones.
          semesters_away_date = ::DatesService.find_date_x_semesters_away(minimum_starting_date, extra_time + 3)
          extra_time = ::DatesService.get_months_in_interval(minimum_starting_date, semesters_away_date).count
        end
        minimum_ending_date = minimum_starting_date + (extra_time - 1).months
        minimum_ending_date
      end

  end
end
