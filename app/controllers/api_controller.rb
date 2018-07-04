class ApiController < ApplicationController

  prepend_view_path Rails.root.join('app/views')

  rescue_from StandardError do |error|
    render json: {error: "#{error}"}, status: 500
  end

end
