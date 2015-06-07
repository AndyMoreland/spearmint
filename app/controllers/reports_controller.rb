class ReportsController < ApplicationController
  before_filter :authenticate_user!

  def index
    @project = Project.find(params[:project_id])

    # FIXME very error prone and nonrobust querie(s)
    # most recent build
    @build = @project.builds.order(:created_at).includes(:stats).last
  end
end
