class ProjectsController < ApplicationController
  before_filter :authenticate_user!

  helper_method :get_commit

  def index
    @projects = current_user.projects.all.sort_by { |proj|  }
  end

  def create
    @project = Project.find_by_full_name params[:project][:full_name]
    if @project
      @project.users << current_user
    else
      @project = Project.new params[:project].permit(:name, :full_name, :github_id).merge({ users: [current_user] })
    end

    render error: "Failed to add project to watchlist." unless @project.save

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
