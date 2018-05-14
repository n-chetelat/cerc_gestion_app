module Api
  class RecruitmentInfosController < ApiController

    attr_reader :partial_path, :resource_name

    def initialize
      @partial_path = "api/recruitment_infos/recruitment_info"
      @resource_name = :info
    end

    def show
      @resource = RecruitmentInfo.first
    end

  end
end
