module Api
  class PositionsController < ApiController

    attr_reader :partial_path, :resource_name

    def initialize
      @partial_path = "api/positions/position"
      @resource_name = :position
    end

    def index
      @resources = Position.visible.order(:position)
    end

    def form
      @resource = Position.find(params[:id].try(:to_i))
      @form_fields =  [{id: "position_id", label: "Position",
        type: "input-select",
        options: {choices: Position.all.map {|po| {id: po.id, label: po.title}}
        }}]
      @form_fields += @resource.recruitment_form.common_fields
      @form_fields += @resource.recruitment_form.form_fields.order(position: :asc).map do |field|
        options = { choices: field.choices_with_locale, optional: field.optional }
        field.attributes.symbolize_keys.slice(:id, :label).merge(
          type: "input-#{field.form.to_s.gsub(/_/, "-")}",
          options: options
        )
      end
    end

  end
end
