module Api
  class RecruitmentInfosController < ApiController

    def show
      @resource = RecruitmentInfo.first
    end

    def partial_path
      "api/recruitment_infos/recruitment_info"
    end

    def resource_name
      :info
    end

  end
end
