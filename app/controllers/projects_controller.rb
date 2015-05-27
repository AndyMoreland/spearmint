class ProjectsController < ApplicationController
  before_filter :authenticate_user!

  helper_method :get_commit
  
  def index
    @projects = current_user.projects.all
  end
  
  def create
    @project = Project.new(params[:project].permit(:name, :full_name, :github_id))

    render error: "Failed to add project to watchlist." unless @project.save
    current_user.projects << @project

    flash[:notice] = "Now watching #{@project.name}"
    redirect_to controller: :pages, action: :index
  end

  def show
    @project = Project.find(params[:id])
  end

  def get_commit(build)
    github_client.commit(@project.full_name, build.commit)
  end
end
