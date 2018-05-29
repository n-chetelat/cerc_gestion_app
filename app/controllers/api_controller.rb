class ApiController < ApplicationController

  prepend_view_path Rails.root.join('app/views')

  rescue_from StandardError do |error|
    render json: {error: "#{error.status_code} - #{error}"}, status: error.try(:status_code)
  end

end
