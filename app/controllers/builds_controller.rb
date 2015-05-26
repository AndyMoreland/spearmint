class BuildsController < ApplicationController
  before_filter :load_project
  skip_before_action :verify_authenticity_token
  
  def new
  end

  def create
    @build = @project.builds.build(params[:build].try(:permit, :title, :commit))
    @build.commit = @project.github_client.repo(@project.full_name).rels[:commits].get.data.first.sha
    
    unless @build.save
      render error: "Can't find project with id #{params[:project_id]}"
    end
    
    flash[:notice] = "Created build."
    redirect_to(@project)
  end

  def show
    @build = @project.builds.find(params[:id])
  end

  protected

  def load_project
    @project = Project.find(params[:project_id])

    render error: "can't find project" unless @project
  end
end
