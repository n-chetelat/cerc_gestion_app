module Api
  class PositionsController < ApiController

    def index
      @resources = Position.all
    end

    def form
      @resource = Position.find(params[:id].try(:to_i))
      @form_fields = @resource.recruitment_form.form_fields.order(position: :asc).map do |field|
        field.attributes.symbolize_keys.slice(:label, :options).merge(type: "input-#{field.form}")
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
