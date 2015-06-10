class ProjectsController < ApplicationController
  before_filter :authenticate_user!

  helper_method :get_commit

  def index
    @projects = current_user.projects.all.sort_by { |proj|  }
  end

  def create
    @project = Project.find_by_full_name(params[:project][:full_name])
    if @project
      @project.users << current_user
    else
      @project = Project.new(params[:project].permit(:name, :full_name, :github_id).merge({ users: [current_user] }))
    end

    render error: "Failed to add project to watchlist." unless @project.save

    if @project.allowed_to_webhook?
      flash[:notice] = "Now watching #{@project.name}"
    else
      flash[:warn] = "Now watching #{@project.name}, but GitHub integration is disabled due to ownership"
    end
    redirect_to controller: :pages, action: :index
  end

  def show
    @project = Project.find(params[:id])
  end

  def destroy
    project = Project.find(params[:id])
    project.destroy
    flash[:notice] = "Stopped watching #{project.name}"
    redirect_to controller: :pages, action: :index
  end
end
