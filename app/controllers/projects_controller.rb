class ProjectsController < ApplicationController
  before_filter :authenticate_user!
  
  def index
    @projects = current_user.projects.all
  end
  
  def create
    @project = Project.new(params[:project].permit(:name, :full_name))
    @project[:github_token] = current_user.client_token

    render error: "Failed to add project to watchlist." unless @project.save
    current_user.projects << @project

    flash[:notice] = "Now watching #{@project.name}"
    redirect_to controller: :pages, action: :index
  end
end
