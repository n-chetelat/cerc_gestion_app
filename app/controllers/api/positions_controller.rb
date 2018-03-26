module Api
  class PositionsController < ApiController

    def index
      @resources = Position.visible
    end

    def form
      @resource = Position.find(params[:id].try(:to_i))
      @form_fields = Positions::RecruitmentForm.common_fields
      @form_fields += @resource.recruitment_form.form_fields.order(position: :asc).map do |field|
        options = { choices: field.choices_with_locale }
        field.attributes.symbolize_keys.slice(:id, :label).merge(
          type: "input-#{field.form.to_s.gsub(/_/, "-")}",
          options: options
        )
      end

      render json: {position_id: @resource.id, form: @form_fields}
    end

    def partial_path
      "api/positions/position"
    end

    def resource_name
      :position
    end

  end
end
