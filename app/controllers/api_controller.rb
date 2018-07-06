class ApiController < ApplicationController

  prepend_view_path Rails.root.join('app/views')

  # rescue_from StandardError do |error|
  #   status_code = (error.respond_to?(:status_code) && error.status_code) ? error.status_code : 500
  #   render json: {error: "#{status_code} - #{error}"}, status: status_code
  # end

end
