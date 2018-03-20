class StaticController < ApplicationController

  def form
    @info = RecruitmentInfo.first
  end
end
