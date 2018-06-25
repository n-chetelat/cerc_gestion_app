module Api
  class StartingDatesController < ApiController
    before_action :authenticate_admin_user!

    def semesters
      render json: ProfileField.generate_starting_dates(:semester)
    end

    def months
      render json: ProfileField.generate_starting_dates(:month)
    end

  end
end
