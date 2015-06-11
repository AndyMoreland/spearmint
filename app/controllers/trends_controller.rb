class TrendsController < ApplicationController
  before_filter :authenticate_user!

  def show
    @project = Project.find(params[:project_id])
    @data = @project.stats.where(source: params[:report_source]).map do |stat|
      { date: stat.build.created_at, value: stat.data[params[:statistic]] }
    end

    respond_to do |f|
      f.json { render json: @data.to_json }
    end
  end
end
